package org.osflash.futures
{
	public class InstantFutureSuccess extends BaseFuture implements Future
	{
		protected var args:Array
		
		public function InstantFutureSuccess(args:Array)
		{
			this.args = args
		}
		
		override public function onCompleted(f:Function):Future
		{
			assertListenerArguments(f, args.length)
			f.apply(null, args)
			return this;
		}
		
		override public function onCancelled(f:Function):Future
		{
			return this;
		}
	}
}