package org.osflash.futures
{
	public class Future implements IFuture
	{
		public function Future()
		{
		}
		
		public function get isPast():Boolean
		{
			return false;
		}
		
		public function onProgress(callback:Function):IFuture
		{
			return null;
		}
		
		public function progress(unit:Number):void
		{
		}
		
		public function onCompleted(f:Function):IFuture
		{
			return null;
		}
		
		public function get hasCompletedListeners():Boolean
		{
			return false;
		}
		
		public function get completedListeners():int
		{
			return 0;
		}
		
		public function complete(...args):void
		{
		}
		
		public function mapComplete(funcOrObject:Object):IFuture
		{
			return null;
		}
		
		public function onCancelled(f:Function):IFuture
		{
			return null;
		}
		
		public function get hasCancelledListeners():Boolean
		{
			return false;
		}
		
		public function get cancelledListeners():int
		{
			return 0;
		}
		
		public function cancel(...args):void
		{
		}
		
		public function mapCancel(funcOrObject:Object):IFuture
		{
			return null;
		}
		
		public function dispose():void
		{
		}
	}
}