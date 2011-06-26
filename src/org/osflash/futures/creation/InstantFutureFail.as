package org.osflash.futures.creation
{
	import org.osflash.futures.Future;
	import org.osflash.futures.support.InstantFuture;
	import org.osflash.futures.support.assertListenerArguments;

	public class InstantFutureFail extends InstantFuture
	{
		public function InstantFutureFail(args:Array)
		{
			super(args)
		}
		
		override public function onCancelled(f:Function):Future
		{
			assertListenerArguments(f, args)
			
			notify = function (...errgs):void {
				f.apply(null, errgs)
			}
			
			cancelItern.apply(null, [[notify], args])
			
			return this
		}
		
		override public function onCompleted(f:Function):Future
		{
			return this
		}
		
		override public function andThen(createProxy:Function):Future
		{
			return this
		}
	}
}