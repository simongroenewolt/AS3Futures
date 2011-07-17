package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	
	import org.osflash.functional.applyArgs;
	
	public class TimedFutureFail extends TimedFuture
	{
		public function TimedFutureFail(name:String, duration:int, args:Array)
		{
			super(name, duration, args)
		}
		
		override protected function buildCallback(duration:int, args:Array):Function
		{
			return function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				cancel.apply(null, args)
			}
		}
	}
}