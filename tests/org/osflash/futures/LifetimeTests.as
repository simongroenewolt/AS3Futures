package org.osflash.futures
{
	import asunit.framework.IAsync;
	import org.osflash.futures.creation.Future;

	public class LifetimeTests
	{
		[Inject]
		public var async:IAsync
		
		[Test(expects="Error")]
		public function shouldFailDueToMultiComplete():void
		{
			const future:IFuture = new Future()
			future.cancel()
			future.cancel()
		}
		
		[Test(expects="Error")]
		public function shouldFailDueToMultiCancel():void
		{
			const future:IFuture = new Future()
			future.complete()
			future.complete()
		}
		
//		[Test]
//		public function compoundCancel():void
//		{
//			const futureA:IFuture = new Future()
//			const futureB:IFuture = new Future()
//			const futureAB:IFuture = futureA.waitOnCritical(futureB)
//			
//			futureAB.cancel()
//		}
	}
}