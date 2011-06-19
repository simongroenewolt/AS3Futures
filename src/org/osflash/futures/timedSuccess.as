package org.osflash.futures 
{
	public function timedSuccess(duration:int, ...args):Future 
	{
		return new TimedFutureSuccess(duration, args)
	}
}