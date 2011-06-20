package org.osflash.futures.support
{
	import org.osflash.futures.Future;

	/**
	 * throws an error if this given future has past (is satisfied, has shifted off this mortal coil)
	 * @param future
	 */
	public function assertFutureIsAlive(future:Future, message:String=null):void 
	{
		message = message || 'future is past, move on, stop trying to relive it'
		if (future.isPast) 
			throw new Error(message)
	}
}