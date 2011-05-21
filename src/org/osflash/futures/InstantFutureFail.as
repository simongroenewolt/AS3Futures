package org.osflash.futures
{
	public class InstantFutureFail extends BaseFuture implements Future
	{
		protected var args:Array
		
		public function InstantFutureFail(...args)
		{
			this.args = args
		}
		
		override public function onCompleted(f:Function):Future
		{
			return this;
		}
		
		override public function onCancelled(f:Function):Future
		{
			assertListenerArgumentLength(f, args.length)
			f.apply(null, args)
			return this;
		}
	}
}