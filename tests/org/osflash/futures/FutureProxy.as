package org.osflash.futures
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class FutureProxy implements IFuture
	{
		protected var 
			future:IFuture,
			completeProxy:Function,
			cancelProxy:Function
		
		public function FutureProxy(future:IFuture, completeProxy:Function=null, cancelProxy:Function=null)
		{
			this.future = future
			this.completeProxy = completeProxy
			this.cancelProxy = cancelProxy
		}
		
		public function get isPast():Boolean
		{
			return future.isPast
		}
			
		protected function proxy(methodName:String, args:Array):*
		{
			const func:Function = future[methodName]
			const result:* = func.apply(null, args)
				
			if (result is IFuture)
			{
				return new FutureProxy(result, completeProxy)
			}
		}
		
		public function onComplete(f:Function):IFuture
		{
			return proxy('onCompleted', [f])
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get hasCompletedListeners():Boolean
		{
			return proxy('hasCompletedListeners', [])
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function get completedListeners():int
		{
			return proxy('completedListeners', [])
		}
		
		public function complete(...args):void
		{
			if (completeProxy != null)	completeProxy(future)
			else						future.complete.apply(args)
		}
		
		public function mapComplete(funcOrObject:Object):IFuture
		{
			return proxy('mapComplete', [funcOrObject])
		}
		
		public function onCancel(f:Function):IFuture
		{
			return proxy('onCancelled', [f])
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get hasCancelledListeners():Boolean
		{
			return proxy('hasCancelledListeners', [])
		}
		
		public function get cancelledListeners():int
		{
			return proxy('cancelledListeners', [])
		}
		
		public function cancel(...args):void
		{
			if (cancelProxy != null)	cancelProxy(future)
			else						future.cancel.apply(null, args)
		}
		
		public function mapCancel(funcOrObject:Object):IFuture
		{
			return proxy('mapCancel', [funcOrObject])	
		}
		
		public function andThen(f:Function):IFuture
		{
			return proxy('andThen', [f])	
		}		
		
		public function orThen(f:Function):IFuture
		{
			return proxy('orThen', [f])
		}
		
		public function orElseCompleteWith(funcOrObject:Object):IFuture
		{
			return proxy('orElseCompleteWith', [funcOrObject])
		}
		
		public function waitOnCritical(...otherFutures):IFuture
		{
			return proxy('waitOnCritical', otherFutures)
		}
		
		public function get hasProgressListener():Boolean
		{
			return proxy('hasProgressListener', [])
		}
		
		public function get hasCompleteListener():Boolean
		{
			return proxy('hasCompleteListener', [])
		}
		
		public function get hasCancelListener():Boolean
		{
			return proxy('hasCancelListener', [])
		}
		
		public function onProgress(callback:Function):IFuture // unit:Number
		{
			return proxy('onProgress', [callback])
		}
		
		public function isolate():IFuture
		{
			return proxy('isolate', [])
		}
			
		public function progress(unit:Number, ...args):void
		{
			args.unshift(unit)
			proxy('progress', args)
		}
		
		public function dispose():void
		{
			future.dispose()
		}
	}
}