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
			
			buildFutureFail = function (...args):Future {
				args.unshift(duration)
				return timedFail.apply(null, args)
			}
			
			futureA = buildFutureFail(argAFail)
			futureB = buildFutureFail(argBFail)
			futureC = buildFutureFail(argCFail)
		}
	}
}