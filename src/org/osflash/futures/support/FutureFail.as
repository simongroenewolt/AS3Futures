package org.osflash.futures.support
{
	import org.osflash.futures.Future;

	public class FutureFail extends BaseFuture
	{
		protected var 
			args:Array,
			notify:Function
		
		public function FutureFail(args:Array)
		{
			this.args = args
		}
				
		override protected function listenToProxyFuture(proxyFuture:BaseFuture):void 
		{
			proxyFuture.afterComplete(notify)
			proxyFuture.afterCancel(notify)
		}
	}
}