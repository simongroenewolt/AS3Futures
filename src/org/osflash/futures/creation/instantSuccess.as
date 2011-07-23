package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;

	public function instantSuccess(name:String, ...args):IFuture 
	{
		return new TimedFutureSuccess(name, 1, args)
	}
}