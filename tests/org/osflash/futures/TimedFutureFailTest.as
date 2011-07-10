package org.osflash.futures
{
	import org.osflash.futures.creation.timedFail;

	public class TimedFutureFailTest extends FailTestsBase
	{
		[Before]
		public function setup():void 
		{
			const duration:int = 200
			asyncTimeout = 250
			
			buildFutureFail = function (...args):IFuture {
				args.unshift(duration)
				return timedFail.apply(null, args)
			}
			
			futureA = buildFutureFail(argAFail)
			futureB = buildFutureFail(argBFail)
			futureC = buildFutureFail(argCFail)
		}
		
		[After]
		override public function dispose():void
		{
			// Don't dispose the futures prematurely, since we are dealing with time here
		}
	}
}