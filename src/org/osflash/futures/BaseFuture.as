package org.osflash.futures
{
	/**
	 * The base class of all Future implementations.  
	 */	
	public class BaseFuture implements Future
	{
		/**
		 * true if the Future is completed or cancelled, as in it is now something that exists in the past. 
		 */		
		protected var
			_isPast:Boolean = false
			
		public function BaseFuture()
		{
		}
				
		public function get isPast():Boolean
		{
			return _isPast
		}
		
		protected function assetFutureIsNotPast():void
		{
			if (_isPast) throw new Error('future is past, move on, stop trying to relive it')
		}
		
		public function onCompleted(f:Function):Future
		{
			assetFutureIsNotPast()
			return this
		}
		
		public function complete(...args):void
		{
			assetFutureIsNotPast()
		}
		
		public function onCancelled(f:Function):Future
		{
			assetFutureIsNotPast()
			return this
		}
		
		public function cancel(...args):void
		{
			assetFutureIsNotPast()
		}
		
		public function dispose():void 
		{
			_isPast = true
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			assetFutureIsNotPast()
			return new SyncedFuture([this].concat(otherFutures))
		}
	}
}