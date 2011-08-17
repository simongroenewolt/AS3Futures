package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.functional.applyArgs;
	import org.osflash.futures.support.assertFutureIsAlive;

	public class TimedFuture extends Future
	{
		protected var 
			t:Timer,
			callback:Function,
			_duration:int
			
		public function TimedFuture(duration:int, args:Array, callback:Function)
		{
			_duration = duration
			t = new Timer(duration, 1)
			this.callback = callback
			t.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				// the timer seems to not stop sometimes
				if (!_isPast)	callback(e)
			})
			t.start()
		}
		
		override public function dispose():void
		{
			callback = null
			t = null
			super.dispose()
		}
		
		protected function stopTimer():void
		{
			assertFutureIsAlive(this)
			t.removeEventListener(TimerEvent.TIMER, callback)
			t.stop()
		}
		
		override public function complete(...args):void
		{
			stopTimer()
			super.complete.apply(null, args)
		}
		
		override public function cancel(...args):void
		{
			stopTimer()
			applyArgs(super.cancel, args)
		}
	}
}