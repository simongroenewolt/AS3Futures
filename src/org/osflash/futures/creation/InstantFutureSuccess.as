package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;
	import org.osflash.futures.support.InstantFuture;
	import org.osflash.futures.support.assertListenerArguments;

	public class InstantFutureSuccess extends InstantFuture
	{
		public function InstantFutureSuccess(args:Array)
		{
			super(args)
		}
		
		override public function onComplete(f:Function):IFuture
		{
			assertListenerArguments(f, args)
			
			notify = function (...errgs):void {
				f.apply(null, errgs)
			}
			
			completeItern.apply(null, [[notify], args])
			
			return this
		}
		
		/**
		 * @inheritDoc
		 */
		override public function andThen(futureGenerator:Function):IFuture
		{
			super.andThen(futureGenerator)
			notify = function (...errgs):void {
				args = errgs
			}
			completeItern.apply(null, [[], args])
			return this
		}
		
		override public function orThen(f:Function):IFuture
		{
			return this
		}
		
		override public function onCancel(f:Function):IFuture
		{
			return this;
		}
	}
}