package org.osflash.futures
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class TimedFutureSuccess extends BaseFuture
	{
		public function TimedFutureSuccess(duration:int, args:Array)
		{
			const t:Timer = new Timer(duration, 1)
			t.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				completeItern.apply(null, args)
			})
		}
	}
}