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
			const future:Future = new TypedFuture()
			future.cancel()
			future.cancel()
		}
		
		[Test(expects="Error")]
		public function shouldFailDueToMultiCancel():void
		{
			const future:Future = new TypedFuture()
			future.complete()
			future.complete()
		}
		
		[Test]
		public function compoundCancel():void
		{
			const futureA:Future = new TypedFuture()
			const futureB:Future = new TypedFuture()
			const futureAB:Future = futureA.waitOnCritical(futureB)
			
			futureAB.cancel()
		}
	}
}