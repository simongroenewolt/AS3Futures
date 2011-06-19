package org.osflash.futures
{
	public class InstantFutureSuccessTest extends SuccessTests
	{
		[Before]
		public function setup():void 
		{
			buildFutureSuccess = function (...args):Future {
				return instantSuccess.apply(null, args)
			}
			
			futureA = buildFutureSuccess(argASuccess)
			futureB = buildFutureSuccess(argBSuccess)
			futureC = buildFutureSuccess(argCSuccess)
		}
	}
}