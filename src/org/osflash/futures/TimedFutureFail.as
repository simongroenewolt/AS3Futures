package org.osflash.futures
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class TimedFutureFail extends BaseFuture
	{
		public function TimedFutureFail(duration:int, args:Array)
		{
			const t:Timer = new Timer(duration, 1)
			t.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				cancelItern.apply(null, args)
			})
		}
	}
}