package org.osflash.futures.support
{
	import org.osflash.futures.Future;

	public class FutureSuccess extends BaseFuture
	{
		protected var args:Array
		
		public function FutureSuccess(args:Array)
		{
			this.args = args
		}
		
//		override public function beforeComplete(f:Function):Future
//		{
//			return onCompleted(f)
//		}
//		
//		override public function beforeCancel(f:Function):Future
//		{
//			return onCancelled(f)
//		}
		
//		override protected function completeItern(...args):void
//		{
//			_beforeComplete.apply(null, args)
//			_onComplete.dispatch(args)
//		}
		
		override public function onCompleted(f:Function):Future
		{
			assertListenerArguments(f, args.length)
			
			args.unshift(function (...errgs):void {
				f.apply(null, errgs)
			})
			
			completeItern.apply(
				null,
				args
			)
			
			return this
		}
		
//		override public function andThen(createProxy:Function):Future
//		{
//			assertFutureIsAlive(this)
//			
//			if (proxyFuture != null && !proxyFuture.isPast)
//				throw new Error('An andThen Future is already active on this Future')
//			
//			const futureSuccess:FutureSuccess = this
//			proxyFuture = createProxy.apply(null, args)
//			
//			assertFutureIsAlive(proxyFuture, 'the future generated for andThen proxy is already past')
//				
//			proxyFuture.beforeComplete(function (...args):void {
//				futureSuccess.args = args
//			})
//			
//			return this
//		}
		
		override public function orThen(f:Function):Future
		{
			return this
		}
		
		override public function onCancelled(f:Function):Future
		{
			return this;
		}
	}
}