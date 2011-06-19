package org.osflash.futures
{
	public function timedFail(duration:int, ...args):Future 
	{
		return new TimedFutureFail(duration, args)
	}
}