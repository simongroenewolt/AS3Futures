package org.osflash.futures.support
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.futures.IFuture;
	import org.osflash.futures.creation.SyncedFuture;
	import org.osflash.futures.creation.instantFail;
	import org.osflash.futures.creation.instantSuccess;
	import org.osmf.events.TimeEvent;

	/**
	 * The base class of all Future implementations.  
	 */	
	public class BaseFuture implements IFuture
	{
		protected const 
			_onCancel:Array = [],
			_onComplete:Array = [],
			_onProgress:Array = []
			
		protected var
			// called just before all the public listeners when this future is cancelled
			_beforeCancel:Function = null,
			_afterCancel:Function = null,
			// called just before all the public listeners when this future is completed
			_beforeComplete:Function = null,
			_afterComplete:Function = null,
			
			// true if the Future is completed or cancelled, as in it is now something that exists in the past.
			// any attept to call functions to adjust the state of this future when it is past on will throw an error
			_isPast:Boolean = false,	
			
			// if set the andThen proxy is called which generates a nextFuture 
			andThenProxy:FutureProxy,
			_mapComplete:Object, // can be a function or a plain Object, if it's a function, arguments will be applied and it will resolve to an object
			
			orThenProxy:FutureProxy,
			_mapCancel:Object, // can be a function or a plain Object, if it's a function, arguments will be applied and it will resolve to an object
			_mapCancelToComplete:Object
			
		/**
		 * @inheritDoc
		 */
		public function dispose():void 
		{
//			assertFutureIsAlive(this)
			_isPast = true
			_onComplete.length = 0
			_onCancel.length = 0
		}	
			
		/**
		 * @inheritDoc
		 */
		public function get isPast():Boolean
		{
			return _isPast
		}
		
		/**
		 * An admin function for other classes to register a single complete listener that will run before the consumer listeners will
		 * @param f the function to callback
		 * @return this Future
		 */		
		public function beforeComplete(f:Function):IFuture
		{
			assertFutureIsAlive(this)
			
			if (_beforeComplete != null)
				throw new Error('beforeComplete is already set on this Future')
			
			_beforeComplete = f
			return this
		}
		
		/**
		 * An admin function for other classes to register a single complete listener that will run after the consumer listeners are notified
		 * @param f the function to callback
		 * @return this Future
		 */		
		public function afterComplete(f:Function):IFuture
		{
			assertFutureIsAlive(this)
			
			if (_afterComplete != null)
				throw new Error('afterComplete is already set on this Future')
			
			_afterComplete = f
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function onCompleted(f:Function):IFuture
		{
			assertFutureIsAlive(this)
			_onComplete.push(f)
			return this
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get hasCompleteListener():Boolean
		{
			return _onComplete.length > 0
		}
		
		public function get completedListeners():int
		{
			return _onComplete.length
		}
		
		protected function map(mapper:Object, args:Array):Array
		{
			const mappedArgs:* = (mapper is Function) 
				? mapper.apply(null, args)
				: mapper
				
			if (mappedArgs is Array)
				return mappedArgs
			else
				return [mappedArgs]
		}
		
		protected function applyArgs(f:Function, mappedArgs:Object):*
		{
			if (mappedArgs is Array)
				return f.apply(null, mappedArgs)
			else
				return f(mappedArgs)
		}
		
		/**
		 * @inheritDoc
		 */
		public function complete(...args):void
		{
			if (andThenProxy != null && andThenProxy.hasFuture)
				throw new Error('This future has been defered to an andThen proxy')
				
			if(completeItern(_onComplete, args))
			{
				dispose()
			}
		}
		
		/**
		 * 
		 * @param notifyFunctionList
		 * @param args
		 * @return true if the call resulted in a dispatch 
		 * 
		 */		
		protected function completeItern(notifyFunctionList:Array, args:Array):Boolean
		{
			assertFutureIsAlive(this)
			
			var hasDispatched:Boolean = false
			
			// if there is an andThen function, do not complete this future 
			// but proxy the completion task to the Future created by the andThen function
			if (_mapComplete != null)
			{
				args = map(_mapComplete, args)
				_mapComplete = null
			}
			
			if (andThenProxy != null && !andThenProxy.hasFuture)
			{
				// get the next future in the sequence
				createProxyFuture(andThenProxy, args)
			}
			else
			{
				if (_beforeComplete != null)	
					_beforeComplete.apply(null, args)
				
				dispatchComplete(notifyFunctionList, args)
				
				if (_afterComplete != null)	
					_afterComplete.apply(null, args)
						
				hasDispatched = true
			}
			
			return hasDispatched
		}
		
		protected function completeIternAndNotifyListeners(...args):void {
			completeItern(_onComplete, args)
		}
		
		protected function cancelIternAndNotifyListeners(...args):void {
			cancelItern(_onCancel, args)
		}
		
		/**
		 * 
		 * @param createProxy
		 * @param args
		 * @return 
		 * 
		 */		
		protected function createProxyFuture(proxy:FutureProxy, args:Array):BaseFuture
		{
			const proxyFuture:BaseFuture = applyArgs(proxy.futureGenerator, args)
			proxy.future = proxyFuture
			assertFutureIsAlive(proxyFuture)
			listenToProxyFuture(proxyFuture)
			return proxyFuture
		}
		
		protected function listenToProxyFuture(proxyFuture:BaseFuture):void 
		{
			proxyFuture.afterComplete(completeIternAndNotifyListeners)
			proxyFuture.afterCancel(cancelIternAndNotifyListeners)
		}
		
		protected function notifyCompleteListeners(...args):void
		{
			dispatch(_onComplete, args)	
		}
		
		protected function notifyCancelListeners(...args):void
		{
			dispatch(_onCancel, args)
		}
		
		/**
		 * An admin function for other classes to register a single cancel listener that will run before the consumer listeners will 
		 * @param f the function to callback
		 * @return this Future
		 */		
		public function beforeCancel(f:Function):IFuture
		{
			assertFutureIsAlive(this)
			
			if (_beforeCancel != null)
				throw new Error('beforeCancel is already set on this Future')
				
			_beforeCancel = f
			return this
		}
		
		/**
		 * An admin function for other classes to register a single cancel listener that will run before the consumer listeners will 
		 * @param f the function to callback
		 * @return this Future
		 */		
		public function afterCancel(f:Function):IFuture
		{
			assertFutureIsAlive(this)
			
			if (_afterCancel != null)
				throw new Error('afterCancel is already set on this Future')
			
			_afterCancel = f
			return this
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function onCancelled(f:Function):IFuture 
		{ 
			assertFutureIsAlive(this)
			_onCancel.push(f)
			return this 
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get hasCancelListener():Boolean
		{
			return _onCancel.length > 0
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get hasProgressListener():Boolean
		{
			return _onProgress.length > 0
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function get cancelledListeners():int
		{
			return _onCancel.length
		}
		
		/**
		 * @inheritDoc 
		 */
		public function cancel(...args):void
		{
			if (orThenProxy != null && orThenProxy.hasFuture)
				throw new Error('This future has been defered to an orTElse proxy')
				
			if(cancelItern(_onCancel, args))
			{
				dispose()
			}
		}
		
		/**
		 * Admin function 
		 * @param args
		 */		
		protected function cancelItern(notifyFunctionList:Array, args:Array):Boolean
		{
			assertFutureIsAlive(this)
			
			var hasDispatched:Boolean = false
			
			if (_mapCancel != null)
			{
				args = map(_mapCancel, args)
			}
			else if (_mapCancelToComplete != null)
			{
				args = map(_mapCancelToComplete, args)
				return complete.apply(null, args) 
			}
			
			if (orThenProxy != null && !orThenProxy.hasFuture)
			{
				// get the next future in the sequence
				createProxyFuture(orThenProxy, args)
			}
			else
			{
				if (_beforeCancel != null)	
					_beforeCancel.apply(null, args)
				
				dispatchCancel(notifyFunctionList, args)
					
				if (_afterCancel != null)	
					_afterCancel.apply(null, args)
						
				hasDispatched = true
			}
			
			return hasDispatched
		}
		
		/**
		 * @inheritDoc
		 */		
		public function andThen(futureGenerator:Function):IFuture
		{
			assertFutureIsAlive(this)
			
			if (andThenProxy != null)
				throw new Error('This Future already has an unsatisfied andThen proxy')
				
			andThenProxy = new FutureProxy(futureGenerator)
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function orThen(futureGenerator:Function):IFuture
		{
			assertFutureIsAlive(this)
			orThenProxy = new FutureProxy(futureGenerator)
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapComplete(funcOrObject:Object):IFuture
		{
			assertFutureIsAlive(this)
			
			if (_mapComplete != null)
				throw new Error('This Future already has a mapComplete set')
				
			_mapComplete = funcOrObject
				
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapCancel(funcOrObject:Object):IFuture
		{
			assertFutureIsAlive(this)
			
			if (_mapCancel != null)
				throw new Error('This Future already has a mapCancel set')
			
			_mapCancel = funcOrObject
				
			return this	
		}
		
		/**
		 * @inheritDoc
		 */
		public function orElseCompleteWith(funcOrObject:Object):IFuture
		{
			if (_mapCancelToComplete != null)
				throw new Error('This Future already has a orElseCompleteWith/mapCancelToComplete set')
				
			_mapCancelToComplete = funcOrObject
			return this
		}
		
		private function dispatch(functionList:Array, args:Array):void
		{
			for each (var f:Function in functionList)
			{
				f.apply(null, args)
			}
		}
		
		protected function dispatchCancel(functionList:Array, args:Array):void
		{
			dispatch(functionList, args)
		}
		
		protected function dispatchComplete(functionList:Array, args:Array):void
		{
			dispatch(functionList, args)
		}
		
		/**
		 * @inheritDoc
		 */
		public function waitOnCritical(...otherFutures):IFuture
		{
			assertFutureIsAlive(this)
			return new SyncedFuture([this].concat(otherFutures))
		}
		
		public function onProgress(f:Function):IFuture
		{
			assertFutureIsAlive(this)
			_onProgress.push(f)
			return this
		}
		
		public function progress(unit:Number):void
		{
			assertFutureIsAlive(this)
			dispatch(_onProgress, [unit])
		}
	}
}

import org.osflash.futures.IFuture;
import org.osflash.futures.support.BaseFuture;
import org.osflash.futures.support.assertFutureIsAlive;

class FutureProxy
{
	protected var 
		_futureGenerator:Function
		
	public var
		future:BaseFuture
		
	public function get futureGenerator():Function { return _futureGenerator }
			
	public function FutureProxy(futureGenerator:Function)
	{
		_futureGenerator = futureGenerator
	}
	
	public function get hasFuture():Boolean
	{
		return future != null
	}
}