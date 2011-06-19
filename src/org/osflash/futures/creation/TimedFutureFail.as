package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.futures.support.FutureFail;

	public class TimedFutureFail extends FutureFail
	{
		public function TimedFutureFail(duration:int, args:Array)
		{
			super(args)
			const t:Timer = new Timer(duration, 1)
			t.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				cancelItern.apply(null, args)
			})
			t.start()
		}
	}
}