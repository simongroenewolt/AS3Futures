package org.osflash.futures.support
{
	import org.osflash.futures.IFuture;

	public class InstantFuture extends BaseFuture
	{
		protected var 
			args:Array,
			notify:Function
		
		public function InstantFuture(args:Array)
		{
			this.args = args
		}
		
		override public function complete(...args):void
		{
			
		}
		
		override public function cancel(...args):void
		{
			
		}
		
		override public function progress(unit:Number, ...args):void
		{
				
		}
		
		override public function beforeComplete(f:Function):IFuture
		{
			return onComplete(f)
		}
		
		override public function afterComplete(f:Function):IFuture
		{
			return onComplete(f)
		}
		
		override public function beforeCancel(f:Function):IFuture
		{
			return onCancel(f)
		}
		
		override public function afterCancel(f:Function):IFuture
		{
			return onCancel(f)
		}
		
		override protected function listenToProxyFuture(proxyFuture:BaseFuture):void 
		{
			proxyFuture.afterComplete(notify)
			proxyFuture.afterCancel(notify)
		}
	}
}