package org.osflash.futures
{
	import org.osflash.futures.creation.instantSuccess;

	public class InstantFutureSuccessTest extends SuccessTestsBase
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