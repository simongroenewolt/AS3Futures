package org.osflash.futures
{
	import asunit.asserts.assertEquals;

	public class SuccessTestsBase extends FuturesTestBase
	{
		[Test]
		public function NoArgs():void
		{
			const future:Future = buildFutureSuccess()
			
			future.onCompleted(async(emptyCallback))
			future.onCancelled(failCallback)
		}
		
		[Test]
		public function Args():void
		{
			const future:Future = buildFutureSuccess('arg', [1 ,2])
			
			future.onCompleted(async(function (a:String, b:Array):void {
			}))
			
			future.onCancelled(failCallback)
		}
		
		[Test(expects="ArgumentError")]
		public function WrongListenerSigniture():void
		{
			const future:Future = buildFutureSuccess('arg', [1 ,2])
			
			future.onCompleted(function (a:String):void {
			})
			
			future.onCancelled(failCallback)
		}
		
		[Test]
		public function AndThen_Map():void
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
		public function AndThenDepthOne():void
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
		public function AndThenDepthTwo():void
		{
			futureA
				.andThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argCSuccess, result)
			}))
		}
		
		[Test]
		public function OrThenDepthTwo_TerminationAtDepthOne():void
		{
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.orThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argASuccess, result)
			}))
		}
		
		[Test]
		public function OrThenDepthTwo_TerminationAtDepthOneWithLeadingAndThen():void
		{
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argASuccess, result)
			}))
		}
		
		[Test]
		public function OrThenDepthTwo_TerminationAtDepthTwo():void
		{
			futureA
				.andThen(function (resultA:String):Future {
					return futureB.orThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCancelled(buildFail("futureA can never fail, it's a sequence of success Futures"))
			
			futureA.onCompleted(async(function (result:String):void {
				assertEquals(argBSuccess, result)
			}))
		}
	}
}