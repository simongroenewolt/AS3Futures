package org.osflash.futures.creation
{
	import flash.events.TimerEvent;
	
	import org.osflash.functional.applyArgs;
	
	public class TimedFutureFail extends TimedFuture
	{
		public function TimedFutureFail(duration:int, args:Array)
		{
			var errorFromCallingScope:Error = new Error()
			
			super(duration, args, function (e:TimerEvent):void {
				t.removeEventListener(e.type, arguments.callee)
				try
				{
					cancel.apply(null, args)
				}
				catch(err:Error)
				{
					errorFromCallingScope.message = err.message
					throw errorFromCallingScope
				}
			})
		}
	}
}