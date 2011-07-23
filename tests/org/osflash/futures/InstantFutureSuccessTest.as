package org.osflash.futures
{
	import org.osflash.futures.creation.instantSuccess;

	public class InstantFutureSuccessTest extends SuccessTestsBase
	{
		public function InstantFutureSuccessTest() 
		{
			buildFutureSuccess = function (...args):IFuture {
				return instantSuccess.apply(null, args)
			}
		}
	}
}