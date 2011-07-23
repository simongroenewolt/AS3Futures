package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;

	public function timedFail(name:String, duration:int, ...args):IFuture 
	{
		return new TimedFutureFail(name, duration, args)
	}
}