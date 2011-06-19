package org.osflash.futures.creation 
{
	import org.osflash.futures.Future;

	public function timedSuccess(duration:int, ...args):Future 
	{
		return new TimedFutureSuccess(duration, args)
	}
}