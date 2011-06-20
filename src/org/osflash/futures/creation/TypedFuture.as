package org.osflash.futures.creation
{
	import org.osflash.futures.FutureProgressable;
	import org.osflash.futures.support.BaseFuture;
	import org.osflash.futures.support.ListenerList;
	import org.osflash.futures.support.assertFutureIsAlive;

	public class TypedFuture extends BaseFuture implements FutureProgressable
	{
		protected const
			_onProgress:ListenerList = new ListenerList([Number])
		
		public function TypedFuture(completeTypes:Array=null, cancelTypes:Array=null)
		{	
			if (completeTypes)	_onComplete = new ListenerList(completeTypes)
			if (cancelTypes)	_onCancel = new ListenerList(cancelTypes)
		}
		
		override public function dispose():void
		{
			super.dispose()
			_onProgress.dispose()
		}
		
		public function onProgress(f:Function):FutureProgressable
		{
			assertFutureIsAlive(this)
			_onProgress.add(f)
			return this
		}
			
		public function progress(unit:Number):void
		{
			assertFutureIsAlive(this)
			_onProgress.dispatch([unit])
		}
	}
}