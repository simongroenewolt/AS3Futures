package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;

	public function instantFail(name:String, ...args):IFuture 
	{
		return new TimedFutureFail(name, 1, args)
	}
}