package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.futures.IFuture;
	import org.osflash.futures.support.BaseFuture;
	import org.osflash.futures.support.assertFutureIsAlive;

	public class TimedFutureSuccess extends BaseFuture
	{
		protected var 
			t:Timer,
			callback:Function
		
		public function TimedFutureSuccess(duration:int, args:Array)
		{
			t = new Timer(duration, 1)
			callback = function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				completeItern(_onComplete, args)
			}
			
			t.addEventListener(TimerEvent.TIMER, callback)
			t.start()
		}
		
		override public function cancel(...args):void
		{
			assertFutureIsAlive(this)
			t.stop()
			t.removeEventListener(TimerEvent.TIMER, callback)
			super.cancel.apply(null, args)
		}
	}
}