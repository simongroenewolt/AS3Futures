package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	
	import org.osflash.futures.support.applyArgs;

	public class TimedFutureFail extends TimedFuture
	{
		public function TimedFutureFail(duration:int, args:Array)
		{
			super(duration, args)
		}
		
		override protected function buildCallback(duration:int, args:Array):Function
		{
			return function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				applyArgs(cancel, args)
			}
		}
	}
}