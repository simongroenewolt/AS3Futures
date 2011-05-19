package org.osflash.futures
{
	import org.osflash.signals.ISignalBinding;
	import org.osflash.signals.SignalBinding;

	/**
	 * The base class of all Future implementations.  
	 */	
	public class BaseFuture implements Future
	{
		/**
		 * Holds signal bindings so that they can be easily cleaned up  
		 */		
		protected const 
			bindings:Array = []
			
		public function BaseFuture()
		{
		}
		
		protected function addBinding(binding:ISignalBinding):void
		{
			bindings.push(binding)
		}
		
		public function onCompleted(f:Function):Future
		{
			return this
		}
		
		public function complete(...args):void
		{
			
		}
		
		public function onCancelled(f:Function):Future
		{
			return this
		}
		
		public function cancel(...args):void
		{
			
		}
		
		public function dispose():void 
		{
			// remove all listenning functions
			for each (var binding:SignalBinding in bindings)
			{
				binding.remove()
			}
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			return new SyncedFuture([this].concat(otherFutures))
		}
	}
}