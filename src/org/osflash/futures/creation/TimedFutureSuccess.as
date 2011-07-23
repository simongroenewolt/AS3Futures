package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	
	import org.osflash.functional.applyArgs;
	
	public class TimedFutureSuccess extends TimedFuture
	{
		public function TimedFutureSuccess(duration:int, args:Array)
		{
			super(duration, args)
		}
		
		override protected function buildCallback(duration:int, args:Array):Function
		{
			return function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				applyArgs(complete, args)
			}
		}
	}
}