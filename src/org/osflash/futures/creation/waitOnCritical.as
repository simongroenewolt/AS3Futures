package org.osflash.futures 
{
	public function waitOnCritical(...futures):Future
	{
		var compoundFuture:Future = futures[0]
		
		for (var i:int=1; i<futures.length; ++i)
		{
			var future:Future = futures[i]
			compoundFuture = compoundFuture.waitOnCritical(future)
		}
		
		return compoundFuture
	}
}