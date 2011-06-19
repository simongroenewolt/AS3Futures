package org.osflash.futures
{
	public function instantSuccess(...args):Future 
	{
		return new InstantFutureSuccess(args)
	}
}