package org.osflash.futures
{
	/**
	 * A Future that alerts listening functions of it's progress in completing the asynchronous operation. 
	 */	
	public interface FutureProgressable extends Future
	{
		/**
		 * @param callback The function to call with progress data. It's signiture should be function(unit:Number):void.
		 * Unit is a unit range number [0->1] 
		 * @return the same FutureProgressable so that functions can be chained
		 */		
		function onProgress(callback:Function):FutureProgressable // unit:Number
			
		/**
		 * update all listening functions of the progress of this future
		 * @param unit
		 */			
		function progress(unit:Number):void
	}
}