package org.osflash.futures.support
{
	import org.osflash.futures.IFuture;

	/**
	 * throws an error if this given future has past (is satisfied, has shifted off this mortal coil)
	 * @param future
	 */
	public function assertFutureIsAlive(future:IFuture, message:String=null):void 
	{
		message = message || "Future:"+future.name+" is past, you can't go back to the future"
		if (future.isPast) 
			throw new Error(message)
	}
}