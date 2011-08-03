package org.osflash.futures.creation 
{
	import org.osflash.futures.IFuture;
	
	public function waitOnCriticalArr(name:String, futures:Array):IFuture
	{
		return waitOnCritical.apply(null, [name].concat(futures))
	}
}	