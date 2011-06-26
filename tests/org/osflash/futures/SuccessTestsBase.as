package org.osflash.futures
{
	import asunit.asserts.assertEquals;
	
	import org.osflash.futures.support.BaseFuture;

	public class SuccessTestsBase extends FuturesTestBase
	{
		[Test]
		public function noArgsGivenShouldMeanAnyArgsAccepted():void
		{
			const future:Future = buildFutureSuccess()
			
			future.onCompleted(async(emptyCallback))
			future.onCancelled(failCallback)
		}
		
		[Test]
		public function argsGivenShouldMapToComplete():void
		{
			const future:Future = buildFutureSuccess('arg', [1 ,2])
			
			future.onCompleted(async(function (a:String, b:Array):void {
			}))
			
			future.onCancelled(failCallback)
		}
		
//		[Test(expects="ArgumentError")]
//		public function unsymetricalListenerSignitureShouldFail():void
//		{
//			const future:Future = buildFutureSuccess('arg', [1 ,2])
//			
//			future.onCompleted(async(function (a:String):void {
//			}))
//			
//			future.onCancelled(failCallback)
//		}
		
		[Test]
		public function argsFrom_AndThenFutureB_ShouldMapToComplete():void
		{
			futureA
				.andThen(function (resultA:String):Future {
					return futureB
				})
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argBSuccess, result)
			}))
		}
		
		[Test]
		public function argsFrom_AndThenFutureC_ShouldMapToComplete():void
		{
			futureA
				.andThen(function (resultA:String):Future {
					return futureB
						.andThen(function (resultB:String):Future {
							return futureC
						})
				})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argCSuccess, result)
			}))
		}
		
		[Test]
		public function argsFrom_FutureA_ShouldMapToComplete_OrThenOrThenChainIgnored():void
		{
			futureA
				.orThen(function (resultA:String):Future {
					return futureB
						.orThen(function (resultB:String):Future {
							return futureC
						})
				})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argASuccess, result)
			}))
		}
		
		[Test]
		public function argsFrom_FutureB_ShouldMapToComplete_LeafOrThenIgnored():void
		{
			futureA
			.andThen(function (resultA:String):Future {
				return futureB
				.orThen(function (resultB:String):Future {
					return futureC
				})
			})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argBSuccess, result)
			}))
		}
		
		[Test]
		public function argsFrom_AndThenMappedFutureB_ShouldMapToComplete():void
		{
			futureA
				.andThen(function (resultA:String):Future {					
					return futureB
						.mapComplete(function (resultB:String):String {
							return resultB + "mapped" 
						})
				})
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argBSuccess + "mapped", result)
			}))
		}
		
		[Test]
		public function argsFrom_FutureA_ShouldMapToComplete_OrThenAndThenChainIgnored():void
		{
			futureA
				.orThen(function (resultA:String):Future {
					return futureB
						.andThen(function (resultB:String):Future {
							return futureC
						})
				})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argASuccess, result)
			}))
		}
	}
}