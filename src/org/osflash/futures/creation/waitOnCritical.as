package org.osflash.futures.creation 
{
	import org.osflash.functional.applyArgs;
	import org.osflash.futures.IFuture;

	public function waitOnCritical(name:String, ...futures):IFuture
	{
		const first:IFuture = futures.shift()
		return applyArgs(first.waitOnCritical, [name].concat(futures))
	}
}