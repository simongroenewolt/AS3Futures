package org.osflash.futures.creation 
{
	import org.osflash.futures.IFuture;

	public function timedSuccess(name:String, duration:int, ...args):IFuture 
	{
		return new TimedFutureSuccess(name, duration, args)
	}
}