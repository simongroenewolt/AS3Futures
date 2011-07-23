package org.osflash.futures
{
	import asunit.asserts.assertEquals;

	public class FailTestsBase extends FuturesTestBase
	{
		[Test]
		public function noArgsGivenShouldMeanAnyArgsAccepted():void
		{
			const future:IFuture = buildFutureFail()
			
			future.onComplete(failCallback)
			future.onCancel(async(emptyCallback))
		}
		
		[Test]
		public function argsGivenShouldMapToComplete():void
		{
			const future:IFuture = buildFutureFail('arg', [1, 2])
			
			future.onComplete(failCallback)
			future.onCancel(async(function (a:String, b:Array):void {}))
		}
		
//		[Test(expects="ArgumentError")]
//		public function unsymetricalListenerSignitureShouldFail():void
//		{
//			const future:Future = buildFutureFail('arg', [1 ,2])
//			
//			future.onComplete(failCallback)
//			future.onCancel(async(function (a:String):void {}))
//		}
		
		[Test]
		public function argsFrom_OrThenFutureB_ShouldMapToCancel():void
		{
			futureA
				.orThen(function (resultA:String):IFuture {
					return futureB
				})
			
			futureA.onComplete(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancel(async(function (result:String):void {
				assertEquals(argBFail, result)
			}))
		}
		
		[Test]
		public function argsFrom_OrThenFutureC_ShouldMapToCancel():void
		{
			futureA
				.orThen(function (resultA:String):IFuture {
					return futureB
						.orThen(function (resultB:String):IFuture {
							return futureC
						})
				})
			
			futureA.onComplete(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancel(async(function (result:String):void {
				assertEquals(argCFail, result)
			}))
		}
		
		[Test]
		public function argsFrom_FutureA_ShouldMapToCancel_AndThenAndThenChainIgnored():void
		{
			futureA
				.andThen(function (resultA:String):IFuture {
					return futureB
						.andThen(function (resultB:String):IFuture {
							return futureC
						})
				})
			
			futureA.onComplete(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancel(async(function (result:String):void {
				assertEquals(argAFail, result)
			}))
		}
		
		[Test]
		public function argsFrom_OrThenFutureB_ShouldMapToCancel_LeafAndThenIgnored():void
		{
			futureA
				.orThen(function (resultA:String):IFuture {
					return futureB
						.andThen(function (resultB:String):IFuture {
							return futureC
						})
				})
			
			futureA.onComplete(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancel(async(function (result:String):void {
				assertEquals(argBFail, result)
			}))
		}
	}
}