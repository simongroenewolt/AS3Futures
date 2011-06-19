package org.osflash.futures
{
	import asunit.asserts.assertEquals;

	public class FailTests extends FuturesTestBase
	{
		[Test(expects="ArgumentError")]
		public function WrongListenerSigniture():void
		{
			const future:Future = buildFutureFail('arg', [1 ,2])
			
			future.onCompleted(failCallback)
			future.onCancelled(function (a:String):void {})
		}
		
		[Test]
		public function NoArgs():void
		{
			const future:Future = buildFutureFail()
			
			future.onCompleted(failCallback)
			future.onCancelled(async.add(emptyCallback))
		}
		
		[Test]
		public function Args():void
		{
			const future:Future = buildFutureFail('arg', [1, 2])
			
			future.onCompleted(failCallback)
			future.onCancelled(async.add(function (a:String, b:Array):void {}))
		}
		
		[Test]
		public function AndThenDepthOne():void
		{
			futureA
				.orThen(function (resultA:String):Future {
					return futureB
				})
			
			futureA.onCompleted(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argBFail, result)
			}))
		}
		
		[Test]
		public function OrThenDepthTwo_FailChain():void
		{
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.orThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCompleted(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argCFail, result)
			}))
		}
		
		[Test]
		public function AndThenDepthTwo_FailAtDepthOne():void
		{
			futureA
				.andThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCompleted(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argAFail, result)
			}))
		}
		
		[Test]
		public function AndThenDepthTwo_FailAtDepthTwo():void
		{
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCompleted(buildFail("futureA can never succeed, it's a sequence of fail Futures"))
			
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argBFail, result)
			}))
		}
	}
}