package org.osflash.futures.support
{
	import org.osflash.futures.Future;
	import org.osflash.futures.creation.SyncedFuture;
	import org.osflash.futures.creation.instantFail;
	import org.osflash.futures.creation.instantSuccess;

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
			
			// true if the Future is completed or cancelled, as in it is now something that exists in the past.
			// any attept to call functions to adjust the state of this future when it is past on will throw an error
			_isPast:Boolean = false,	
			
			// if set the andThen proxy is called which generates a nextFuture 
			_andThenProxy:FutureProxy,
			_mapComplete:Object, // can be a function or a plain Object, if it's a function, arguments will be applied and it will resolve to an object
			
			_orThenProxy:FutureProxy,
			_mapCancel:Object // can be a function or a plain Object, if it's a function, arguments will be applied and it will resolve to an object
			
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
		public function beforeComplete(f:Function):Future
		{
			assertFutureIsAlive(this)
			
			if (_beforeComplete != null)
				throw new Error('beforeComplete is already set on this Future')
			
			_beforeComplete = f
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function onCompleted(f:Function):Future
		{
			assertFutureIsAlive(this)
			_onComplete.add(f)
			return this
		}
		
		protected function map(mapper:Object, args:Array):*
		{
			return (mapper is Function) 
				? mapper.apply(null, args)
				: mapper
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
			completeItern(notifyCompleteListeners, args)
			dispose()
		}
				
		protected function completeItern(notify:Function, ...args:Array):void
		{
			assertFutureIsAlive(this)
			
			if (_andThenProxy != null && _andThenProxy.hasFuture)
				throw new Error('This future has been defered to an andThen proxy')
			
			// if there is an andThen function, do not complete this future 
			// but proxy the completion task to the Future created by the andThen function
			if (_mapComplete != null)
			{
				args = map(_mapComplete, args)
			}
			
			if (_andThenProxy != null)
			{// get the next future in the sequence
				_andThenProxy.future = createProxyFuture(_andThenProxy.futureGenerator, args)
			}
			else
			{
				_beforeComplete.apply(null, args)
				notify.apply(null, args)
			}
		}
		
		protected function completeIternAndNotifyListeners(...args):void {
			completeItern(notifyCompleteListeners, args)
		}
		
		protected function cancelIternAndNotifyListeners(...args):void {
			completeItern(notifyCompleteListeners, args)
		}
		
		/**
		 * 
		 * @param createProxy
		 * @param args
		 * @return 
		 * 
		 */		
		protected function createProxyFuture(createProxy:Function, args:Array):BaseFuture
		{
			const proxyFuture:BaseFuture = applyArgs(createProxy, args)
			
			assertFutureIsAlive(proxyFuture)
			
			proxyFuture.beforeComplete(completeIternAndNotifyListeners)
			proxyFuture.beforeCancel(cancelIternAndNotifyListeners)
			
			return proxyFuture
		}
		
		protected function notifyCompleteListeners(...args):void
		{
			_onComplete.dispatch(args)	
		}
		
		protected function notifyCancelListeners(...args):void
		{
			_onCancel.dispatch(args)	
		}
		
		/**
		 * An admin function for other classes to register a single cancel listener that will run before the consumer listeners will 
		 * @param f the function to callback
		 * @return this Future
		 */		
		public function beforeCancel(f:Function):Future
		{
			assertFutureIsAlive(this)
			
			if (_beforeCancel != null)
				throw new Error('beforeCancel is already set on this Future')
				
			_beforeCancel = f
			return this
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function onCancelled(f:Function):Future 
		{ 
			assertFutureIsAlive(this)
			_onCancel.add(f)
			return this 
		}
		
		/**
		 * @inheritDoc 
		 */
		public function cancel(...args):void
		{
			cancelItern(notifyCancelListeners, args)
			dispose()
		}
		
		/**
		 * Admin function 
		 * @param args
		 */		
		protected function cancelItern(notify:Function, ...args):void
		{
			assertFutureIsAlive(this)
			
			if (_mapCancel != null)
			{
				args = map(_mapCancel, args)
			}
			
			if (_orThenProxy != null)
			{
				if (_orThenProxy.hasFuture)
					throw new Error('This future has been defered to an orTElse proxy')
				
				// get the next future in the sequence
				_orThenProxy.future = createProxyFuture(_orThenProxy.futureGenerator, args)
			}
			else
			{
				_beforeCancel.apply(null, args)
				notify.apply(null, args)
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function andThen(futureGenerator:Function):Future
		{
			assertFutureIsAlive(this)
			
			if (_andThenProxy != null)
				throw new Error('This Future is already has an andThen proxy set')
				
			_andThenProxy = new FutureProxy(futureGenerator)
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function orThen(futureGenerator:Function):Future
		{
			assertFutureIsAlive(this)
			_orThenProxy = new FutureProxy(futureGenerator)
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapComplete(funcOrObject:Object):Future
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
		public function mapCancel(funcOrObject:Object):Future
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
		public function orElseCompleteWith(funcOrObject:Object):Future
		{
			_mapCancel = funcOrObject
			
//			_mapCancel = function (...args):Future {
//				
//				const mappedArgs:* = (funcOrObject is Function) 
//					? funcOrObject.apply(null, args)
//					: funcOrObject
//				
//				if (mappedArgs is Array)
//					return instantSuccess.apply(null, mappedArgs)
//				else
//					return instantSuccess(mappedArgs)
//			})
				
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void 
		{
//			assertFutureIsAlive(this)
			_isPast = true
			_onComplete.dispose()
			_onCancel.dispose()
		}
		
		/**
		 * @inheritDoc
		 */
		public function waitOnCritical(...otherFutures):Future
		{
			assertFutureIsAlive(this)
			return new SyncedFuture([this].concat(otherFutures))
		}
	}
}

import org.osflash.futures.Future;
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