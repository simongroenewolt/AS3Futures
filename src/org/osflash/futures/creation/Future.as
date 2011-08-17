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
			_onComplete:Function,		// called when the future is completed, with the arguments supplied by the consumer
			_afterComplete:Function,	// called after the future is completed, with the arguments supplied by the consumer
			_mapComplete:Object,		// called if set, to convert the arguments given during the Future completion into another form
			completing:Boolean,			// true if the Future is currently in the process of completing (used to avoid recursive completing)
			
			_onCancel:Function,			// called when the future is cancelled, with the arguments supplied by the consumer
			_afterCancel:Function,		// called after the future is cancelled, with the arguments supplied by the consumer
			_mapCancel:Object,			// called if set, to convert the arguments given during the Future cancellation into another form
			_mapCancelToComplete:Object,// called if set, to convert the arguments given during the Future cancellation into another form
			cancelling:Boolean,			// true if the Future is currently in the process of cancelling (used to avoid recursive cancelling)
			
			_onProgress:Function,		// called on every progress update with at least a unit range argument
			_afterProgress:Function,	// called after every progress update with at least a unit range argument
			_isPast:Boolean, 			// true if the future has already happened (ended with either completed or cancel)
			
			// I listen to the proxy
			proxyAnd:FutureProxy,
			proxyOr:FutureProxy,
			
			// isolator listens to me
			isolator:Future,
			
			standardErrorMessage:String
			
		public function Future()
		{
			standardErrorMessage = errorMessage()
		}
		
		public function setName(value:String):IFuture
		{
			_name = value
			return this
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
		
		public function get isCancelled():Boolean
		{
			return cancelling
		}
			
		public function get isCompleted():Boolean
		{
			return completing
		}
		
		/**
		 * @inheritDoc
		 */
		public function isolate():IFuture
		{
			assertAll(isolator, 'is already isolated')
			isolator = new Future()
			isolator._name = _name+'-isolated'
				
//			isolator.afterComplete(complete)
//			isolator.afterCancel(cancel)
			admin::afterComplete(isolator.complete)
			admin::afterCancel(isolator.cancel)
				
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
		
		public function get hasIsolatedProgressListener():Boolean
		{
			return (
				isolator != null
				&&
				isolator.hasProgressListener
			)
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
		
		admin function afterComplete(f:Function):void
		{
			assertNotNull(_afterComplete, 'is already handling afterComplete ')
			_afterComplete = f
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasCompleteListener():Boolean
		{
			return _onComplete != null
		}
		
		public function get hasIsolatedCompleteListener():Boolean
		{
			return (
				isolator != null
				&&
				isolator.hasCompleteListener
			)
		}
		
		/**
		 * @inheritDoc
		 */
		public function complete(...args):void
		{
			// ignore complete request while still cancelling, this is brute force recursion avoidance
			if (completing)	
				return
			
			assertThisFutureIsAlive()
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
				completing = true
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
			proxyFuture.admin::afterComplete(completeIternAndNotifyListeners)
			proxyFuture.admin::afterCancel(cancelIternAndNotifyListeners)
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
		
		admin function afterCancel(f:Function):void
		{
			assertNotNull(_afterCancel, 'is already handling afterCancel')
			_afterCancel = f
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasCancelListener():Boolean
		{
			return (
				_onCancel != null
				||
				_afterCancel != null
				||
				_mapCancelToComplete != null
				||
				hasIsolatedCancelListener
			)
		}
		
		public function get hasIsolatedCancelListener():Boolean
		{
			return (
				isolator != null
				&&
				(isolator && isolator.hasCancelListener)
			)
		}
		
		/**
		 * @inheritDoc
		 */		
		public function cancel(...args):void
		{
			// ignore cancel request while still cancelling, this is brute force recursion avoidance
			if (cancelling)
				return
			
			assertThisFutureIsAlive()
			
			if (proxyOr != null && proxyOr.hasFuture)
				throw new Error(errorMessage('is already defered to an orElse proxy'))
			
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
				applyArgs(complete, args)
				return
			}
			
			if (proxyOr != null && !proxyOr.hasFuture)
			{
				// get the next future in the sequence
				createProxyFuture(proxyOr, args)
			}
			else
			{
				cancelling = true
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
		
		public function waitOnCritical(...otherFutures):IFuture
		{
			if (otherFutures.length == 0)
			{
				return this
			}
			else
			{
				otherFutures.unshift(this)
				return new SyncedFuture(otherFutures)
			}
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
				throw new Error(errorMessage(message))
		}
		
		protected function errorMessage(message:String=''):String
		{
			return "Future:"+_name+" has thrown an Error:\n\t"+message
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