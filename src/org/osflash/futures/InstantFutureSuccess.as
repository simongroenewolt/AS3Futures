package org.osflash.futures
{
	public class InstantFutureSuccess extends BaseFuture implements Future
	{
		protected var args:Array
		
		public function InstantFutureSuccess(...args)
		{
			this.args = args
		}
		
		override public function onCompleted(f:Function):Future
		{
			f.apply(null, args)
			return this;
		}
		
		override public function onCancelled(f:Function):Future
		{
			return this;
		}
	}
}