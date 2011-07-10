package org.osflash.futures.support
{	
	import org.osflash.futures.IFuture;

	/**
	 * Use this class to hold a reference to single Future so that the garbage collector doesn't get it's filth hands on it.
	 * Since this Sentinal refers to a single future, and existing Future references will be disposed of.
	 */	
	public class FutureSentinelSingle
	{
		protected var future:IFuture
		
		public function watch(futureToWatch:IFuture):IFuture 
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
			future = null
		}
	}
}