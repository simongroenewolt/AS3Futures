package org.osflash.futures
{
	import org.osflash.futures.creation.timedSuccess;

	public class TimedFutureSuccessTest extends SuccessTestsBase
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
		
		[After]
		override public function dispose():void
		{
			// Don't dispose the futures prematurely, since we are dealing with time here
		}
	}
}