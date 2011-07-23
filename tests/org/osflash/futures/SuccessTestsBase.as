package org.osflash.futures
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertMatches;

	public class SuccessTestsBase extends FuturesTestBase
	{
//		[Test]
//		public function noArgsGivenShouldMeanAnyArgsAccepted():void
//		{
//			const future:IFuture = buildFutureSuccess()
//			
//			future.onComplete(async(emptyCallback))
//			future.onCancel(failCallback)
//		}
//		
//		[Test]
//		public function argsGivenShouldMapToComplete():void
//		{
//			const future:IFuture = buildFutureSuccess('arg', [1 ,2])
//			
//			future.onComplete(async(function (a:String, b:Array):void {
//			}))
//			
//			future.onCancel(failCallback)
//		}
		
//		[Test(expects="ArgumentError")]
//		public function unsymetricalListenerSignitureShouldFail():void
//		{
//			const future:IFuture = buildFutureSuccess('arg', [1 ,2])
//			
//			future.onComplete(async(function (a:String):void {
//			}))
//			
//			future.onCancel(failCallback)
//		}
		
		[Test]
		public function argsFrom_AndThenFutureB_ShouldMapToComplete():void
		{
			futureA = 
				buildFutureSuccess(argASuccess)
					.andThen(function (resultA:String):IFuture {
						return buildFutureSuccess(argBSuccess)
					})
			
			futureA.onComplete(function (result:String):void {
				trace('BOOOOOOMMMM!')
				assertEquals(argBSuccess, result)
			})
		}
//		
//		[Test]
//		public function argsFrom_AndThenFutureC_ShouldMapToComplete():void
//		{
//			futureA
//				.andThen(function (resultA:String):IFuture {
//					return futureB
//						.andThen(function (resultB:String):IFuture {
//							return futureC
//						})
//				})
//			
//			futureA.onCancel(buildFail("futureA can never fail, it's a sequence of success Futures"))
//			
//			futureA.onComplete(async(function (result:String):void {
//				assertEquals(argCSuccess, result)
//			}))
//		}
//		
//		[Test]
//		public function argsFrom_FutureA_ShouldMapToComplete_OrThenOrThenChainIgnored():void
//		{
//			futureA
//				.orThen(function (resultA:String):IFuture {
//					return futureB
//						.orThen(function (resultB:String):IFuture {
//							return futureC
//						})
//				})
//			
//			futureA.onCancel(buildFail("futureA can never fail, it's a sequence of success Futures"))
//			
//			futureA.onComplete(async(function (result:String):void {
//				assertEquals(argASuccess, result)
//			}))
//		}
//		
//		[Test]
//		public function argsFrom_FutureB_ShouldMapToComplete_LeafOrThenIgnored():void
//		{
//			futureA
//				.andThen(function (resultA:String):IFuture {
//					return futureB
//						.orThen(function (resultB:String):IFuture {
//							return futureC
//						})
//				})
//			
//			futureA.onCancel(buildFail("futureA can never fail, it's a sequence of success Futures"))
//			
//			futureA.onComplete(async(function (result:String):void {
//				assertEquals(argBSuccess, result)
//			}))
//		}
//		
//		[Test]
//		public function argsFrom_AndThenMappedFutureB_ShouldMapToComplete():void
//		{
//			futureA
//				.andThen(function (resultA:String):IFuture {					
//					return futureB
//						.mapComplete(function (resultB:String):String {
//							return resultB + "mapped" 
//						})
//				})
//			
//			futureA.onComplete(async(function (result:String):void {
//				assertEquals(argBSuccess + "mapped", result)
//			}))
//		}
//		
//		[Test]
//		public function argsFrom_FutureA_ShouldMapToComplete_OrThenAndThenChainIgnored():void
//		{
//			futureA
//				.orThen(function (resultA:String):IFuture {
//					return futureB
//						.andThen(function (resultB:String):IFuture {
//							return futureC
//						})
//				})
//			
//			futureA.onCancel(buildFail("futureA can never fail, it's a sequence of success Futures"))
//			
//			futureA.onComplete(async(function (result:String):void {
//				assertEquals(argASuccess, result)
//			}))
//		}
		
//		[Test]
//		public function argsFromFutureA_SYNC_B_ShouldMapToComplete():void 
//		{
//			const compound:IFuture = futureA.waitOnCritical(futureB)
//			
//			compound.onComplete(async(function (resultA:String, resultB:String):void {
//				assertMatches(/^argA/, resultA)
//				assertMatches(/^argB/, resultB)
//			}))
//		}
	}
}