package org.osflash.futures
{
	public class InstantFutureFailTest extends FailTests
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