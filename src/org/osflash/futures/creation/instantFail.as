package org.osflash.futures.creation
{
	import org.osflash.futures.Future;

	public function instantFail(...args):Future 
	{
		return new InstantFutureFail(args)
	}
}