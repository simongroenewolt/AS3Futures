package org.osflash.futures.creation
{
	import org.osflash.futures.Future;

	public function timedFail(duration:int, ...args):Future 
	{
		return new TimedFutureFail(duration, args)
	}
}