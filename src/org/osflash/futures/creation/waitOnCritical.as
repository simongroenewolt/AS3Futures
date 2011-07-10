package org.osflash.futures.creation 
{
	import org.osflash.futures.IFuture;

	public function waitOnCritical(...futures):IFuture
	{
		var compoundFuture:IFuture = futures[0]
		
//		for (var i:int=1; i<futures.length; ++i)
//		{
//			var future:Future = futures[i]
//			compoundFuture = compoundFuture.waitOnCritical(future)
//		}
		
		return compoundFuture
	}
}