package org.osflash.futures.support
{
	import org.osflash.futures.creation.Future;
	import org.osflash.futures.IFuture;

	public function isolate(future:IFuture):IFuture
	{
		return future.isolate()
	}
}