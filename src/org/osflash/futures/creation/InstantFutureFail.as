package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;
	import org.osflash.futures.support.InstantFuture;
	import org.osflash.futures.support.assertListenerArguments;

	public class InstantFutureFail extends InstantFuture
	{
		public function InstantFutureFail(args:Array)
		{
			super(args)
		}
		
		override public function onCancelled(f:Function):IFuture
		{
			assertListenerArguments(f, args)
			
			notify = function (...errgs):void {
				f.apply(null, errgs)
			}
			
			cancelItern.apply(null, [[notify], args])
			
			return this
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function orThen(futureGenerator:Function):IFuture
		{
			super.orThen(futureGenerator)
			const future:InstantFuture = this
			notify = function (...errgs):void {
				args = errgs
			}
			cancelItern.apply(null, [[], args])
			return this
		}
		
		override public function onCompleted(f:Function):IFuture
		{
			return this
		}
		
		override public function andThen(createProxy:Function):IFuture
		{
			return this
		}
	}
}