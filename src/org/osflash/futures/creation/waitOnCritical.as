package org.osflash.futures.creation 
{
	import org.osflash.futures.IFuture;

	public function waitOnCritical(name:String, ...futures):IFuture
	{
		const first:IFuture = futures.shift()
		return first.waitOnCritical.apply(null, [name].concat(futures))
	}
}	