package org.osflash.futures.creation 
{
	import org.osflash.futures.IFuture;

	public function timedSuccess(duration:int, ...args):IFuture 
	{
		return new TimedFutureSuccess(duration, args)
	}
}