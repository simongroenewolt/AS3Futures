package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;

	public function timedFail(duration:int, ...args):IFuture 
	{
		return new TimedFutureFail(duration, args)
	}
}