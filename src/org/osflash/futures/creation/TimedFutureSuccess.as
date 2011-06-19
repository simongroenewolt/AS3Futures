package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.futures.support.FutureSuccess;

	public class TimedFutureSuccess extends FutureSuccess
	{
		public function TimedFutureSuccess(duration:int, args:Array)
		{
			super(args)
			const t:Timer = new Timer(duration, 1)
			t.addEventListener(TimerEvent.TIMER, function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				completeItern.apply(null, args)
			})
			t.start()
		}
	}
}