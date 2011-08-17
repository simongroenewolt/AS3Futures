package org.osflash.futures.creation 
{
	import org.osflash.futures.IFuture;
	
	public function waitOnCriticalArr(futures:Array):IFuture
	{
		return waitOnCritical.apply(null, futures)
	}
}	