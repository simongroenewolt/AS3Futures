package org.osflash.futures
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public class FutureProxy implements FutureProgressable
	{
		protected var 
			future:Future,
			completeProxy:Function,
			cancelProxy:Function
		
		public function FutureProxy(future:Future, completeProxy:Function=null, cancelProxy:Function=null)
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
				
			if (result is Future)
			{
				return new FutureProxy(result, completeProxy)
			}
		}
		
		public function onCompleted(f:Function):Future
		{
			return proxy('onCompleted', [f])
		}
		
		public function complete(...args):void
		{
			if (completeProxy != null)	completeProxy(future)
			else						future.complete.apply(args)
		}
		
		public function mapComplete(funcOrObject:Object):Future
		{
			return proxy('mapComplete', [funcOrObject])
		}
		
		public function onCancelled(f:Function):Future
		{
			return proxy('onCancelled', [f])
		}
		
		public function cancel(...args):void
		{
			if (cancelProxy != null)	cancelProxy(future)
			else						future.cancel.apply(null, args)
		}
		
		public function mapCancel(funcOrObject:Object):Future
		{
			return proxy('mapCancel', [funcOrObject])	
		}
		
		public function andThen(f:Function):Future
		{
			return proxy('andThen', [f])	
		}		
		
		public function orThen(f:Function):Future
		{
			return proxy('orThen', [f])
		}
		
		public function orElseCompleteWith(funcOrObject:Object):Future
		{
			return proxy('orElseCompleteWith', [funcOrObject])
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			return proxy('waitOnCritical', otherFutures)
		}
		
		public function onProgress(callback:Function):FutureProgressable // unit:Number
		{
			return proxy('onProgress', [callback])
		}
			
		public function progress(unit:Number):void
		{
			FutureProgressable(future).progress(unit)
		}
		
		public function dispose():void
		{
			future.dispose()
		}
	}
}