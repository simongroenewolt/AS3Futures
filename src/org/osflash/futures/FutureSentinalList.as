package org.osflash.futures
{
	import flash.utils.Dictionary;
	
	/**
	 * Use this class to hold reference to Futures so that the garbage collector doesn't get it's filth hands on them.
	 * This Sentinal manages a list of Futures and only disposes of them when the are satisfied. 
	 */	
	public class FutureSentinalList
	{
		protected const futures:Dictionary = new Dictionary()
		
		public function watch(futureToWatch:Future):Future
		{
			if (futureToWatch in futures)
				throw new Error('Future is already being watched')
				
			futures[futureToWatch] = futureToWatch
				
			const dispose:Function = disposeFuture(futureToWatch) 
			futureToWatch.onCompleted(dispose)
			futureToWatch.onCancelled(dispose)
				
			return futureToWatch
		}
		
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
		
		protected function disposeFuture(future:Future):Function
		{
			return function (...args):void {
				delete futures[future]
			}
		}
	}
}