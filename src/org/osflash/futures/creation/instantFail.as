package org.osflash.futures
{
	public function instantFail(...args):Future 
	{
		return new InstantFutureFail(args)
	}
}