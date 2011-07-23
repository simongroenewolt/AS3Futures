package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;

	public function instantSuccess(...args):IFuture 
	{
		return new TimedFutureSuccess(1, args)
	}
}