package org.osflash.futures
{
	import asunit.framework.IAsync;
	import org.osflash.futures.creation.TypedFuture;

	public class LifetimeTests
	{
		[Inject]
		public var async:IAsync
		
		[Test(expects="Error")]
		public function shouldFailDueToMultiComplete():void
		{
			const future:IFuture = new TypedFuture()
			future.cancel()
			future.cancel()
		}
		
		[Test(expects="Error")]
		public function shouldFailDueToMultiCancel():void
		{
			const future:IFuture = new TypedFuture()
			future.complete()
			future.complete()
		}
		
		[Test]
		public function compoundCancel():void
		{
			const futureA:IFuture = new TypedFuture()
			const futureB:IFuture = new TypedFuture()
			const futureAB:IFuture = futureA.waitOnCritical(futureB)
			
			futureAB.cancel()
		}
	}
}