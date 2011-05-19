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
			
		protected var
			isDead:Boolean = false
			
		public function BaseFuture()
		{
		}
		
		protected function addBinding(binding:ISignalBinding):void
		{
			bindings.push(binding)
		}
		
		protected function checkDeadness():void
		{
			if (isDead) throw new Error('future is past, move on, stop trying to relive it')
		}
		
		public function onCompleted(f:Function):Future
		{
			checkDeadness()
			return this
		}
		
		public function complete(...args):void
		{
			checkDeadness()
		}
		
		public function onCancelled(f:Function):Future
		{
			checkDeadness()
			return this
		}
		
		public function cancel(...args):void
		{
			checkDeadness()
		}
		
		public function dispose():void 
		{
			isDead = true
			
			// remove all listenning functions
			for each (var binding:SignalBinding in bindings)
			{
				binding.remove()
			}
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			checkDeadness()
			return new SyncedFuture([this].concat(otherFutures))
		}
	}
}