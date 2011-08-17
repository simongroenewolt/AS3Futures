package org.osflash.futures.creation
{
	import org.osflash.functional.applyArgsIfExists;
	import org.osflash.futures.IFuture;
	
	public class FutureTest implements IFuture
	{
		protected var
			_onComplete:Function
			
		protected var
			_onCancel:Function
		
		public function FutureTest()
		{
		}
		
		public function setName(value:String):IFuture
		{
			return this
		}
		
		public function get name():String
		{
			return null;
		}
		
		public function get isPast():Boolean
		{
			return false;
		}
		
		public function get isCancelled():Boolean
		{
			return false;
		}
		
		public function get isCompleted():Boolean
		{
			return false;
		}
		
		public function isolate():IFuture
		{
			return null;
		}
		
		public function onProgress(f:Function):IFuture
		{
			return null;
		}
		
		public function get hasProgressListener():Boolean
		{
			return false;
		}
		
		public function get hasIsolatedProgressListener():Boolean
		{
			return false
		}
		
		public function progress(unit:Number, ...args):void
		{
		}
		
		public function onComplete(f:Function):IFuture
		{
			_onComplete = f
			return this;
		}
		
		public function get hasCompleteListener():Boolean
		{
			return false;
		}
		
		public function get hasIsolatedCompleteListener():Boolean
		{
			return false
		}
		
		public function complete(...args):void
		{
			completeItern(args)
		}
		
		protected function completeItern(args:Array):void
		{
			_onComplete.apply(null, args)
//			applyArgsIfExists(_onComplete, args)
//			applyArgsIfExists(_afterComplete, args)
		}
		
		public function mapComplete(funcOrObject:Object):IFuture
		{
			return null;
		}
		
		public function onCancel(f:Function):IFuture
		{
			_onCancel = f
			return this;
		}
		
		public function get hasCancelListener():Boolean
		{
			return false;
		}
		
		public function get hasIsolatedCancelListener():Boolean
		{
			return false
		}
		
		public function cancel(...args):void
		{
		}
		
		public function mapCancel(funcOrObject:Object):IFuture
		{
			return null;
		}
		
		public function andThen(f:Function):IFuture
		{
			return null;
		}
		
		public function orThen(f:Function):IFuture
		{
			return null;
		}
		
		public function orElseCompleteWith(funcOrObject:Object):IFuture
		{
			return null;
		}
		
		public function waitOnCritical(...otherFutures):IFuture
		{
			return null;
		}
		
		public function dispose():void
		{
		}
	}
}