package org.osflash.futures
{
	import org.osflash.futures.support.assertFutureIsAlive;

	public class Future implements IFuture
	{
		protected var
			_onComplete:Function,
			_onCancel:Function,
			_onProgress:Function,
			_isPast:Boolean
		
		public function get isPast():Boolean
		{
			return _isPast
		}
		
		public function onProgress(f:Function):IFuture
		{
			assertThisFutureIsAlive()
			assertNotNull(_onComplete, 'onProgress is already being handled')
			_onProgress = f;
			return this;
		}
		
		protected function assertThisFutureIsAlive(message:String=null):void 
		{
			assertFutureIsAlive(this, message)
		}
		
		protected function assertNotNull(property:*, message:String):void 
		{
			if (property != null)
				throw new Error(message)
		}
		
		public function progress(unit:Number):void
		{
			assertThisFutureIsAlive()
		}
		
		public function onComplete(f:Function):IFuture
		{
			assertThisFutureIsAlive()
			assertNotNull(_onComplete, 'onComplete is already being handled')
			_onComplete = f
			return this;
		}
		
		public function get hasCompleteListener():Boolean
		{
			return _onComplete;
		}
		
		public function complete(...args):void
		{
			assertThisFutureIsAlive()
		}
		
		public function mapComplete(funcOrObject:Object):IFuture
		{
			return null;
		}
		
		public function onCancel(f:Function):IFuture
		{
			assertThisFutureIsAlive()
			assertNotNull(_onComplete, 'onCancel is already being handled')
			_onCancel = f
			return this;
		}
		
		public function get hasCancelListener():Boolean
		{
			return false;
		}
		
		public function cancel(...args):void
		{
			assertThisFutureIsAlive()
		}
		
		public function mapCancel(funcOrObject:Object):IFuture
		{
			return null;
		}
		
		public function dispose():void
		{
			_onComplete = _onCancel = _onProgress = null
		}
	}
}