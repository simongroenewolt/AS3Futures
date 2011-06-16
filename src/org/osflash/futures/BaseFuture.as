package org.osflash.futures
{
	/**
	 * The base class of all Future implementations.  
	 */	
	public class BaseFuture implements Future
	{
		protected var
			// called just before all the public listeners when this future is cancelled
			_beforeCancel:Function = function ():void {},
			_onCancel:ListenerList = new ListenerList(),
			
			// called just before all the public listeners when this future is completed
			_beforeComplete:Function = function ():void {},
			_onComplete:ListenerList = new ListenerList(),
			
			_isPast:Boolean = false,	// true if the Future is completed or cancelled, as in it is now something that exists in the past.
			
			// if set the andThen  function is called which generates a nextFuture 
			_andThen:Function,
			nextCompleteFuture:BaseFuture,
			
			_orThen:Function,
			nextCancelFuture:BaseFuture,
			
			_orElseCompleteWith:Object 	// function or Object
			
		public function BaseFuture()
		{
		}
				
		public function get isPast():Boolean
		{
			return _isPast
		}
		
		protected function assetFutureIsNotPast(future:Future):void
		{
			if (future.isPast) throw new Error('future is past, move on, stop trying to relive it')
		}
		
		public function beforeComplete(f:Function):Future
		{
			assetFutureIsNotPast(this)
			_beforeComplete = f
			return this
		}
		
		public function onCompleted(f:Function):Future
		{
			assetFutureIsNotPast(this)
			_onComplete.add(f)
			return this
		}
		
		public function complete(...args):void
		{
			assetFutureIsNotPast(this)
			
			if (nextCompleteFuture)
				assetFutureIsNotPast(nextCompleteFuture)
			
			// if there is an andThen function, do not complete this future 
			// but proxy the completion task to the Future created by the antThen function 
			if (_andThen != null)
			{
				// get the next future in the sequence
				nextCompleteFuture = createProxyFuture(_andThen, args)
			}
			else
			{
				completeItern.apply(null, args)
			}
		}
		
		public function createProxyFuture(createProxy:Function, args:Array):BaseFuture
		{
			const proxyFuture:BaseFuture = createProxy.apply(null, args)
			
			proxyFuture.beforeComplete(completeItern)
			proxyFuture.beforeCancel(cancelItern)
				
			return proxyFuture
		}
		
		protected function completeItern(...args):void
		{
			_beforeComplete.apply(null, args)
			_onComplete.dispatch(args)
			dispose()
		}
		
		public function beforeCancel(f:Function):Future
		{
			assetFutureIsNotPast(this)
			_beforeCancel = f
			return this
		}
		
		public function onCancelled(f:Function):Future 
		{ 
			assetFutureIsNotPast(this)
			_onCancel.add(f)
			return this 
		}
		
		public function cancel(...args):void
		{
			assetFutureIsNotPast(this)
			
			if (_orThen != null)
			{
				// get the next future in the sequence
				nextCancelFuture = createProxyFuture(_orThen, args)
			}
			else
			{
				cancelItern(args)
			}
		}
		
		protected function cancelItern(args:Array):void
		{
			_beforeCancel.apply(null, args)
			_onCancel.dispatch(args)
			dispose()
		}
		
		public function andThen(f:Function):Future
		{
			assetFutureIsNotPast(this)
			
			if (nextCompleteFuture != null && !nextCompleteFuture.isPast)
				throw new Error('An andThen Future is already active on this Future')
				
			_andThen = f
			return this
		}
		
		public function orThen(f:Function):Future
		{
			assetFutureIsNotPast(this)
			_orThen = f
			return this
		}
		
		public function mapComplete(f:Function):Future
		{
			andThen(function (...args):Future {
				const mappedArgs:* = f.apply(null, args)
				if (mappedArgs is Array)
					return instantSuccess.apply(null, mappedArgs)
				else
					return instantSuccess(mappedArgs)
			})
			return this
		}
		
		public function mapCancel(f:Function):Future
		{
			orThen(function (...args):Future {
				const mappedArgs:* = f.apply(null, args)
				if (mappedArgs is Array)
					return instantFail.apply(null, mappedArgs)
				else
					return instantFail(mappedArgs) 
			})
			return this
		}
		
		public function orElseCompleteWith(funcOrObject:Object):Future
		{
			orThen(function (...args):Future {
				
				const data:* = (_orElseCompleteWith is Function) 
					? _orElseCompleteWith.apply(null, args)
					: _orElseCompleteWith
				
				return instantSuccess.apply(null, data) 
			})
			return this
		}
		
		public function dispose():void 
		{
//			assetFutureIsNotPast(this)
			_isPast = true
			_onComplete.dispose()
			_onCancel.dispose()
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			assetFutureIsNotPast(this)
			return new SyncedFuture([this].concat(otherFutures))
		}
	}
}