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
		 * Map the arguments of the complete function to another form before they get passed to the listeners (onComplete) 
		 * @param f function of the form: 
		 * 	function (...args):*
		 * @return if an array of values is returned, each array element is passed to the onComplete listeners as single arguments 
		 */			
		function mapComplete(f:Function):Future	
			
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
		 * Map the arguments of the cancel function to another form before they get passed to the listeners (onCancel) 
		 * @param f function of the form: 
		 * 	function (...args):*
		 * @return if an array of values is returned, each array element is passed to the onCancel listeners as single arguments 
		 */
		function mapCancel(f:Function):Future
			
		/**
		 * Chain futures together, where the first Future in the sequence returns what the last Future completes with
		 * @param f a function with signiture:
		 * <pre>
		 * 	function (...args):Future
		 * </pre>
		 * 
		 * @return a modified version of the current Future. The listeners from the other Future are merged into this 
		 * 
		 */			
		function andThen(f:Function):Future
			
		/**
		 * @param f
		 * @return 
		 */			
		function orThen(f:Function):Future
						
		/**
		 * Setting a value to orElse will guarantee that this future will always complete. 
		 * The data supplied to orElse will be given to the complete listeners in the case of a cancelation.
		 * @param funcOrObject an Object or the function to call that returns an Object 
		 * @return the same Future object so method calls can be chained togeter 
		 */			
		function orElseCompleteWith(funcOrObject:Object):Future
			
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