package org.osflash.futures
{	
	/**
	 * Use this class to hold a reference to single Future so that the garbage collector doesn't get it's filth hands on it.
	 * Since this Sentinal refers to a single future, and existing Future references will be disposed of.
	 */	
	public class FutureSentinalSingle
	{
		protected var future:Future
		
		public function watch(futureToWatch:Future):Future 
		{
			if (future != null)
			{
				disposeFuture()
				future = futureToWatch
			}
			
			future = futureToWatch
			future.onCompleted(disposeFuture)
			future.onCancelled(disposeFuture)
			
			return futureToWatch
		}
		
		protected function disposeFuture(...args):void
		{
			future.dispose() 
			future = null
		}
	}
}