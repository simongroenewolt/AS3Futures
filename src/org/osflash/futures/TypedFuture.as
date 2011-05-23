package org.osflash.futures
{
	public class TypedFuture extends BaseFuture implements FutureProgressable
	{
		protected const
			_onProgress:ListenerList = new ListenerList([Number])
			
		protected var
			_onCancel:ListenerList = new ListenerList(),
			_onComplete:ListenerList = new ListenerList()
		
		public function TypedFuture(completeTypes:Array=null, cancelTypes:Array=null)
		{	
			if (completeTypes)	_onComplete = new ListenerList(completeTypes)
			if (cancelTypes)	_onCancel = new ListenerList(cancelTypes)
		}
		
		override public function dispose():void
		{
			isDead = true
				
			_onProgress.dispose()
			_onComplete.dispose()
			_onCancel.dispose()
		}
		
		public function onProgress(f:Function):FutureProgressable
		{
			checkDeadness()
			_onProgress.add(f)
			return this
		}
			
		public function progress(unit:Number):void
		{
			checkDeadness()
			_onProgress.dispatch([unit])
		}
		
		override public function onCompleted(f:Function):Future
		{
			super.onCompleted(f)
			_onComplete.add(f)
			return this
		}
		
		override public function complete(...args):void
		{
			super.complete.apply(null, args)
			_onComplete.dispatch(args)
			dispose()
		}
		
		override public function onCancelled(f:Function):Future 
		{ 
			super.onCancelled(f)
			_onCancel.add(f)
			return this 
		}
		
		override public function cancel(...args):void
		{
			super.cancel.apply(null, args)
			_onCancel.dispatch(args)
			dispose()
		}
	}
}