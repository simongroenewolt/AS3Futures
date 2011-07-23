package org.osflash.futures.creation
{
	import org.osflash.functional.applyArgs;
	import org.osflash.functional.applyArgsIfExists;
	import org.osflash.futures.IFuture;
	import org.osflash.futures.support.assertFutureIsAlive;

	public class Future implements IFuture
	{
		protected var
			_onComplete:Function,
			_afterComplete:Function,
			_mapComplete:Object,
			
			_onCancel:Function,
			_afterCancel:Function,
			_mapCancel:Object,
			_mapCancelToComplete:Object,
			
			_onProgress:Function,
			_afterProgress:Function,
			_isPast:Boolean,
			
			// I listen to the proxy
			proxyAnd:FutureProxy,
			proxyOr:FutureProxy,
			
			// isolator listens to me
			isolator:Future
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			_isPast = true
			_onComplete = _onCancel = _onProgress = null
		}	
			
		/**
		 * @inheritDoc
		 */
		public function get isPast():Boolean
		{
			return _isPast
		}
		
		/**
		 * @inheritDoc
		 */
		public function isolate():IFuture
		{
			assertAll(isolator, 'Isolate has already been called on this Future')
			isolator = new Future()
				
//			isolator.afterComplete(complete)
//			isolator.afterCancel(cancel)
			afterComplete(isolator.complete)
			afterCancel(isolator.cancel)
				
			return isolator
		}
		
		/**
		 * @inheritDoc
		 */
		public function onProgress(f:Function):IFuture
		{
			assertAll(_onComplete, 'onProgress is already being handled')
			_onProgress = f;
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasProgressListener():Boolean
		{
			return _onProgress != null;
		}
		
		public function progress(unit:Number, ...args):void
		{
			assertThisFutureIsAlive()
			
			if (_onProgress != null)
			{
				args.unshift(unit)
				applyArgs(_onProgress, args)
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function onComplete(f:Function):IFuture
		{
			assertAll(_onComplete, 'onComplete is already being handled')
			_onComplete = f
			return this;
		}
		
		protected function afterComplete(f:Function):void
		{
			assertNotNull(_afterComplete, 'onComplete is already being handled')
			_afterComplete = f
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasCompleteListener():Boolean
		{
			return _onComplete != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function complete(...args):void
		{
			assertThisFutureIsAlive()
			
			if (proxyAnd != null && proxyAnd.hasFuture)
				throw new Error('This future has been defered to an andThen proxy')
			
			completeItern(args)
		}
		
		protected function completeItern(args:Array):void
		{
			assertFutureIsAlive(this)
			
			// if there is an andThen function, do not complete this future 
			// but proxy the completion task to the Future created by the andThen function
			if (_mapComplete != null)
			{
				args = map(_mapComplete, args)
				_mapComplete = null
			}
			
			if (proxyAnd != null && !proxyAnd.hasFuture)
			{
				// get the next future in the sequence
				createProxyFuture(proxyAnd, args)
			}
			else
			{
				_isPast = true
				applyArgsIfExists(_onComplete, args)
				applyArgsIfExists(_afterComplete, args)
				dispose()
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapComplete(funcOrObject:Object):IFuture
		{
			assertAll(_mapComplete, 'mapComplete is already being handled')
			_mapComplete = funcOrObject
			return this;
		}
		
		public function andThen(futureGenerator:Function):IFuture
		{
			assertAll(proxyAnd, 'andThen is already being handled')
			proxyAnd = new FutureProxy(futureGenerator)
			return this
		}
		
		protected function createProxyFuture(proxy:FutureProxy, args:Array):IFuture
		{
			const proxyFuture:Future = applyArgs(proxy.futureGenerator, args)
			proxy.future = proxyFuture
			assertFutureIsAlive(proxyFuture)
			listenToProxyFuture(proxyFuture)
			return proxyFuture
		}
		
		protected function listenToProxyFuture(proxyFuture:Future):void 
		{
			proxyFuture.afterComplete(completeIternAndNotifyListeners)
			proxyFuture.afterCancel(cancelIternAndNotifyListeners)
		}
		
		protected function completeIternAndNotifyListeners(...args):void 
		{
			completeItern(args)
		}
		
		protected function cancelIternAndNotifyListeners(...args):void 
		{
			cancelItern(args)
		}
		
		/**
		 * @inheritDoc
		 */
		public function onCancel(f:Function):IFuture
		{
			assertAll(_onCancel, 'onCancel is already being handled')
			_onCancel = f
			return this;
		}
		
		protected function afterCancel(f:Function):void
		{
			assertNotNull(_afterCancel, 'onComplete is already being handled')
			_afterCancel = f
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasCancelListener():Boolean
		{
			return _onCancel != null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function cancel(...args):void
		{
			assertThisFutureIsAlive()
			
			if (proxyOr != null && proxyOr.hasFuture)
				throw new Error('This future has been defered to an orElse proxy')
			
			cancelItern(args)
		}
		
		/**
		 * Admin function 
		 * @param args
		 */		
		protected function cancelItern(args:Array):void
		{
			assertFutureIsAlive(this)
			
			if (_mapCancel != null)
			{
				args = map(_mapCancel, args)
			}
			else if (_mapCancelToComplete != null)
			{
				args = map(_mapCancelToComplete, args)
				complete.apply(null, args) 
			}
			
			if (proxyOr != null && !proxyOr.hasFuture)
			{
				// get the next future in the sequence
				createProxyFuture(proxyOr, args)
			}
			else
			{
				_isPast = true
				applyArgsIfExists(_onCancel, args)
				applyArgsIfExists(_afterCancel, args)
				dispose()
			}
		}
		
		/**
		 * @inheritDocs
		 */
		public function mapCancel(funcOrObject:Object):IFuture
		{
			assertNotNull(_onComplete, 'onCancel is already being handled')
			return null;
		}
		
		public function orThen(futureGenerator:Function):IFuture
		{
			assertAll(proxyOr, 'orThen is already being handled')
			proxyOr = new FutureProxy(futureGenerator)
			return this
		}
		
		public function orElseCompleteWith(funcOrObject:Object):IFuture
		{
			if (_mapCancelToComplete != null)
				throw new Error('This Future already has a orElseCompleteWith/mapCancelToComplete set')
			
			_mapCancelToComplete = funcOrObject
			return this
		}
		
		public function waitOnCritical(...otherFutures):IFuture
		{
			otherFutures.unshift(this)
			return new SyncedFuture(otherFutures)
		}
		
		protected function assertAll(property:*, message:String):void
		{
			assertThisFutureIsAlive()
			assertNotNull(property, message)
		}
		
		protected function assertThisFutureIsAlive(message:String=null):void 
		{
			assertFutureIsAlive(this, message)
		}
		
		protected function assertNotNull(property:*, message:String):void 
		{
			if (property != null)
				throw new Error(message)
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
	}
}

import org.osflash.futures.IFuture;
import org.osflash.futures.creation.Future;

class FutureProxy
{
	protected var 
		_futureGenerator:Function
	
	public var
		future:Future
	
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