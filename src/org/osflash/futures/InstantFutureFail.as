package org.osflash.futures
{
	public class InstantFutureFail extends BaseFuture implements Future
	{
		protected var args:Array
		
		public function InstantFutureFail(args:Array)
		{
			this.args = args
		}
		
		override public function onCancelled(f:Function):Future
		{
			assetFutureIsNotPast(this)
			
			if (_orElseCompleteWith)
			{
				const data:* = (_orElseCompleteWith is Function) 
					? _orElseCompleteWith()
					: _orElseCompleteWith
				
				complete(data)
			}
			else
			{
				assertListenerArguments(f, args.length)
				f.apply(null, args)
				dispose()
			}
			
			return this;
		}
	}
}