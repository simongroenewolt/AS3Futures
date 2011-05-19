package org.osflash.futures
{
	/**
	 * The base class of all Future implementations.  
	 */	
	public class BaseFuture implements Future
	{
		protected var
			isDead:Boolean = false
			
		public function BaseFuture()
		{
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
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			checkDeadness()
			return new SyncedFuture([this].concat(otherFutures))
		}
	}
}