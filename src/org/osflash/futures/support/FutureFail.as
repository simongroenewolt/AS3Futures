package org.osflash.futures.support
{
	import org.osflash.futures.Future;

	public class FutureFail extends BaseFuture
	{
		protected var args:Array
		protected var proxyFuture:BaseFuture
		
		public function FutureFail(args:Array)
		{
			this.args = args
		}
		
		override public function beforeComplete(f:Function):Future
		{
			return onCompleted(f)
		}
		
		override public function beforeCancel(f:Function):Future
		{
			return onCancelled(f)
		}
		
		override public function onCompleted(f:Function):Future
		{
			return this
		}
		
		override public function onCancelled(f:Function):Future
		{
			assetFutureIsNotPast(this)
			assertListenerArguments(f, args.length)
			
			if (proxyFuture)
			{
				proxyFuture.onCancelled(function (...args):void {
					f.apply(null, args)
				})
			}
			else
			{
				f.apply(null, args)
			}
			
			return this;
		}
		
		override public function andThen(createProxy:Function):Future
		{
			return this
		}
		
		override public function orThen(createProxy:Function):Future
		{
			assetFutureIsNotPast(this)
			
			if (proxyFuture != null && !proxyFuture.isPast)
				throw new Error('An orThen Future is already active on this Future')
			
			const futureFail:FutureFail = this
			proxyFuture = createProxy.apply(null, args)
			proxyFuture.onCancelled(function (...args):void {
				futureFail.args = args
			})
			
			return this
		}
	}
}