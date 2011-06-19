package org.osflash.futures.creation
{
	import org.osflash.futures.Future;

	public function instantSuccess(...args):Future 
	{
		return new InstantFutureSuccess(args)
	}
}