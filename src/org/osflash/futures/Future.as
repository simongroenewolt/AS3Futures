package org.osflash.futures
{
	/**
	 * A Future is a representation of the end state of an asynchronous operation.
	 * If a method call results in an async operation such as loading a file of a network request, then return a Future.
	 * The caller can then attached functions to the Future to handle the two outcomes of an operation, Completion or Cancellation. 
	 */	
	public interface Future
	{
		/**
		 * @return true if the Future has past due to it beiing completed or cancelled already 
		 */ 
		function get isPast():Boolean
		
		/**
		 * @param f the function to call if the Future is satified as complete
		 * @return the same Future object so method calls can be chained togeter
		 */		
		function onCompleted(f:Function):Future
			
		/**
		 * Complete this Future
		 * @param args the arguments to pass to all listening functions
		 */			
		function complete(...args):void
			
		/**
		 * @param f 
		 * @return the same Future object so method calls can be chained togeter 
		 */			
		function onCancelled(f:Function):Future
			
		/**
		 * Cancel this Future
		 * @param args the arguments to pass to all listening functions
		 */			
		function cancel(...args):void
			
		/**
		 * Create a new compound Future that waits for both this Future and the other futures supplied
		 * If any of the Futures are cancelled then the compound Future is also cancelled.
		 * @param otherFutures the other Futures to wait on
		 * @return the compound Future that represents a group of Futures
		 */			
		function waitOnCritical(...otherFutures):Future
		
		function dispose():void
	}
}