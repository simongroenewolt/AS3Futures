package org.osflash.futures.support
{
	import org.osflash.futures.Future;

	public class InstantFuture extends BaseFuture
	{
		protected var 
			args:Array,
			notify:Function
		
		public function InstantFuture(args:Array)
		{
			this.args = args
		}
		
		override public function beforeComplete(f:Function):Future
		{
			return onCompleted(f)
		}
		
		override public function afterComplete(f:Function):Future
		{
			return onCompleted(f)
		}
		
		override public function beforeCancel(f:Function):Future
		{
			return onCancelled(f)
		}
		
		override public function afterCancel(f:Function):Future
		{
			return onCancelled(f)
		}
		
		override protected function listenToProxyFuture(proxyFuture:BaseFuture):void 
		{
			proxyFuture.afterComplete(notify)
			proxyFuture.afterCancel(notify)
		}
	}
}