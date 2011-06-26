package org.osflash.futures.creation
{
	import org.osflash.futures.Future;
	import org.osflash.futures.support.InstantFuture;
	import org.osflash.futures.support.assertListenerArguments;

	public class InstantFutureSuccess extends InstantFuture
	{
		public function InstantFutureSuccess(args:Array)
		{
			super(args)
		}
		
		override public function onCompleted(f:Function):Future
		{
			assertListenerArguments(f, args)
			
			notify = function (...errgs):void {
				f.apply(null, errgs)
			}
			
			completeItern.apply(null, [[notify], args])
			
			return this
		}
		
		override public function orThen(f:Function):Future
		{
			return this
		}
		
		override public function onCancelled(f:Function):Future
		{
			return this;
		}
	}
}