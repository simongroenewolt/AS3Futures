package org.osflash.futures
{
	/**
	 * The base class of all Future implementations.  
	 */	
	public class BaseFuture implements Future
	{
		protected var
			_onCancel:ListenerList = new ListenerList(),
			_onComplete:ListenerList = new ListenerList(),
			_isPast:Boolean = false,	// true if the Future is completed or cancelled, as in it is now something that exists in the past.
			_orElseCompleteWith:Object 	// function or Object
			
		public function BaseFuture()
		{
		}
				
		public function get isPast():Boolean
		{
			return _isPast
		}
		
		protected function assetFutureIsNotPast():void
		{
			if (_isPast) throw new Error('future is past, move on, stop trying to relive it')
		}
		
		public function onCompleted(f:Function):Future
		{
			assetFutureIsNotPast()
			_onComplete.add(f)
			return this
		}
		
		public function complete(...args):void
		{
			assetFutureIsNotPast()
			_onComplete.dispatch(args)
			dispose()
		}
		
		public function onCancelled(f:Function):Future 
		{ 
			assetFutureIsNotPast()
			_onCancel.add(f)
			return this 
		}
		
		public function cancel(...args):void
		{
			assetFutureIsNotPast()
			
			if (_orElseCompleteWith)
			{
				const data:* = (_orElseCompleteWith is Function) 
					? _orElseCompleteWith()
					: _orElseCompleteWith
				
				complete(data)
			}
			else
			{
				_onCancel.dispatch(args)
				dispose()
			}
		}
		
		public function orElseCompleteWith(funcOrObject:Object):Future
		{
			_orElseCompleteWith = funcOrObject
			return this
		}
		
		public function dispose():void 
		{
			_isPast = true
			_onComplete.dispose()
			_onCancel.dispose()
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			assetFutureIsNotPast()
			return new SyncedFuture([this].concat(otherFutures))
		}
	}
}