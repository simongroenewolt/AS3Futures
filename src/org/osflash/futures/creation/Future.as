package org.osflash.futures.creation
{
	import org.osflash.functional.applyArgs;
	import org.osflash.functional.applyArgsIfExists;
	import org.osflash.futures.IFuture;
	import org.osflash.futures.support.assertFutureIsAlive;

	public class Future implements IFuture
	{
		protected var
			_name:String, // for debugging
		
			_onComplete:Function,
			_afterComplete:Function,
			_mapComplete:Object,
			
			_onCancel:Function,
			_afterCancel:Function,
			_mapCancel:Object,
			_mapCancelToComplete:Object,
			
			_onProgress:Function,
			_afterProgress:Function,
			_isPast:Boolean, // true if the future has already happened (ended with either completed or cancel)
			
			// I listen to the proxy
			proxyAnd:FutureProxy,
			proxyOr:FutureProxy,
			
			// isolator listens to me
			isolator:Future
			
		public function Future(name:String)
		{
			_name = name
		}
		
		public function get name():String
		{
			return _name
		}
		
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
			assertAll(isolator, 'is already isolated')
			isolator = new Future(_name+'-isolated')
				
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
			assertAll(_onComplete, 'is already handling onProgress')
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
			assertAll(_onComplete, 'is already handling onComplete')
			_onComplete = f
			return this;
		}
		
		protected function afterComplete(f:Function):void
		{
			assertNotNull(_afterComplete, 'is already handling afterComplete ')
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
				throw new Error('Future:'+_name+' is already defered to an andThen proxy')
			
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
			assertAll(_mapComplete, 'is already handling mapComplete')
			_mapComplete = funcOrObject
			return this;
		}
		
		public function andThen(futureGenerator:Function):IFuture
		{
			assertAll(proxyAnd, 'is already handling andThen')
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
			assertAll(_onCancel, 'is already handling onCancel')
			_onCancel = f
			return this;
		}
		
		protected function afterCancel(f:Function):void
		{
			assertNotNull(_afterCancel, 'is already handling afterCancel')
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
				throw new Error('Future:'+_name+' is already defered to an orElse proxy')
			
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
			assertNotNull(_mapCancel, 'is already handling mapCancel')
			return null;
		}
		
		public function orThen(futureGenerator:Function):IFuture
		{
			assertAll(proxyOr, 'is already handling orThen')
			proxyOr = new FutureProxy(futureGenerator)
			return this
		}
		
		public function orElseCompleteWith(funcOrObject:Object):IFuture
		{
			assertNotNull(_mapCancelToComplete, 'is already handling orElseCompleteWith/mapCancelToComplete')
			_mapCancelToComplete = funcOrObject
			return this
		}
		
		public function waitOnCritical(name:String, ...otherFutures):IFuture
		{
			otherFutures.unshift(this)
			return new SyncedFuture(name, otherFutures)
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
				throw new Error('Future:'+_name+' '+message)
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