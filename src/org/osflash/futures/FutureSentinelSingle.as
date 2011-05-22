package org.osflash.futures
{	
	/**
	 * Use this class to hold a reference to single Future so that the garbage collector doesn't get it's filth hands on it.
	 * Since this Sentinal refers to a single future, and existing Future references will be disposed of.
	 */	
	public class FutureSentinelSingle
	{
		protected var future:Future
		
		public function watch(futureToWatch:Future):Future 
		{
			if (future != null)
			{
				cancelFuture()
				future = futureToWatch
			}
			
			future = futureToWatch
			future.onCompleted(disposeFuture)
			future.onCancelled(disposeFuture)
			
			return futureToWatch
		}
		
		protected function cancelFuture(...args):void
		{
			future.cancel()
			disposeFuture()
		}
		
		protected function disposeFuture(...args):void
		{
			future.dispose()
			future = null
		}
	}
}