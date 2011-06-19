package org.osflash.futures
{
	import org.osflash.futures.creation.timedSuccess;

	public class TimedFutureSuccessTest extends SuccessTests
	{
		[Before]
		public function setup():void 
		{
			const duration:int = 200
			asyncTimeout = 250
				
			buildFutureSuccess = function (...args):Future {
				args.unshift(duration)
				return timedSuccess.apply(null, args)
			}
			
			futureA = buildFutureSuccess(argASuccess)
			futureB = buildFutureSuccess(argBSuccess)
			futureC = buildFutureSuccess(argCSuccess)
		}
	}
}