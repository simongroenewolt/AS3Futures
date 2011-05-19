package org.osflash.futures
{
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.SignalBinding;

	public class TypedFuture extends BaseFuture implements FutureProgressable
	{
		protected const
			_onProgress:ISignal = new Signal(Number)
			
		protected const
			_onCancel:Signal = new Signal(),
			_onComplete:Signal = new Signal()
		
		public function TypedFuture(completeTypes:Array=null, cancelTypes:Array=null)
		{	
			_onComplete.valueClasses = completeTypes || []
			_onCancel.valueClasses = cancelTypes || []
		}
		
		public function onProgress(f:Function):FutureProgressable
		{
			bindings.push(_onProgress.add(f))
			return this
		}
			
		public function progress(unit:Number):void
		{
			IDispatcher(_onProgress).dispatch(unit)
		}
		
		override public function onCompleted(f:Function):Future
		{
			bindings.push(_onComplete.addOnce(f))
			return this
		}
		
		override public function complete(...args):void
		{
			IDispatcher(_onComplete).dispatch.apply(null, args)
			dispose()
		}
		
		override public function onCancelled(f:Function):Future 
		{ 
			bindings.push(_onCancel.addOnce(f))
			return this 
		}
		
		override public function cancel(...args):void
		{
			IDispatcher(_onCancel).dispatch.apply(null, args)
			dispose()
		}
	}
}