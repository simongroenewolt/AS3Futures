package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;

	public function instantFail(...args):IFuture 
	{
		return new InstantFutureFail(args)
	}
}