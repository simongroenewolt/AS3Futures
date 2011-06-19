package org.osflash.futures
{
	import org.osflash.futures.creation.instantFail;

	public class InstantFutureFailTest extends FailTestsBase
	{
		[Before]
		public function setup():void 
		{
			buildFutureFail = function (...args):Future {
				return instantFail.apply(null, args)
			}
				
			futureA = buildFutureFail(argAFail)
			futureB = buildFutureFail(argBFail)
			futureC = buildFutureFail(argCFail)
		}
	}
}