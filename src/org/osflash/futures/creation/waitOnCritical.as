package org.osflash.futures.creation 
{
	import org.osflash.futures.IFuture;

	public function waitOnCritical(...futures):IFuture
	{
		if (futures.length == 0)
		{
			return instantSuccess()
		}
		else
		{
			const first:IFuture = futures.shift()
			return first.waitOnCritical.apply(null, futures)
		}
	}
}	