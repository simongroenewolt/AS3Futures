package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.futures.support.BaseFuture;
	import org.osflash.futures.support.FutureFail;
	import org.osflash.futures.support.assertFutureIsAlive;

	public class TimedFutureFail extends BaseFuture
	{
		protected var 
			t:Timer,
			callback:Function
		
		public function TimedFutureFail(duration:int, args:Array)
		{
			t = new Timer(duration, 1)
			callback = function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				cancelItern(_onCancel, args)
			}
				
			t.addEventListener(TimerEvent.TIMER, callback)
			t.start()
		}
		
		override public function complete(...args):void
		{
			assertFutureIsAlive(this)
			t.stop()
			t.removeEventListener(TimerEvent.TIMER, callback)
			super.complete.apply(null, args)
		}
	}
}