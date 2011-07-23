package org.osflash.futures.support
{
	import flash.utils.Dictionary;
	import org.osflash.futures.IFuture;
	
	/**
	 * Use this class to hold reference to Futures so that the garbage collector doesn't get it's filth hands on them.
	 * This Sentinal manages a list of Futures and only disposes of them when the are satisfied. 
	 */	
	public class FutureSentinelList
	{
		protected const futures:Dictionary = new Dictionary()
		
		public function watch(futureToWatch:IFuture):IFuture
		{
			if (futureToWatch in futures)
				throw new Error('Future is already being watched')
				
			futures[futureToWatch] = futureToWatch
				
			const dispose:Function = disposeFuture(futureToWatch) 
			futureToWatch.onComplete(dispose)
			futureToWatch.onCancel(dispose)
				
			return futureToWatch
		}
		
		protected function disposeFuture(future:IFuture):Function
		{
			return function (...args):void {
				delete futures[future]
			}
		}
	}
}