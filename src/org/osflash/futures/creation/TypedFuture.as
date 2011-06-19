package org.osflash.futures.creation
{
	import org.osflash.futures.support.BaseFuture;
	import org.osflash.futures.support.ListenerList;
	import org.osflash.futures.FutureProgressable;

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
			assetFutureIsNotPast(this)
			_onProgress.add(f)
			return this
		}
			
		public function progress(unit:Number):void
		{
			assetFutureIsNotPast(this)
			_onProgress.dispatch([unit])
		}
	}
}