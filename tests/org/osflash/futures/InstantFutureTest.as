package org.osflash.futures
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	public class InstantFutureTest
	{
		[Inject]
		public var async:IAsync
		
		protected const
			argASuccess:String = 'argASuccss',
			argBSuccess:String = 'argBSuccess',
			argCSuccess:String = 'argCSuccess',
			argAFail:String = 'argAFail',
			argBFail:String = 'argBFail',
			argCFail:String = 'argCFail'
			
		protected var
			futureASuccess:Future, 
			futureBSuccess:Future,
			futureCSuccess:Future,
			futureAFail:Future, 
			futureBFail:Future,
			futureCFail:Future
			
		protected const 
			emptyCallback:Function = function (...args):void {},
			failCallback:Function = function (...args):void { fail() };
		
		protected function buildFail(message:String):Function
		{
			return function (...args):void { fail(message) }
		}
			
		[Before]
		public function setup():void 
		{
			futureASuccess = instantSuccess(argASuccess)
			futureBSuccess = instantSuccess(argBSuccess)
			futureCSuccess = instantSuccess(argCSuccess)
			futureAFail = instantFail(argAFail)
			futureBFail = instantFail(argBFail)
			futureCFail = instantFail(argCFail)
		}
			
		[After]
		public function dispose():void
		{
			futureASuccess.dispose()
			futureBSuccess.dispose()
			futureCSuccess.dispose()
			futureAFail.dispose()
			futureBFail.dispose()
			futureCFail.dispose()
		}
		
		[Test]
		public function testSuccessNoArgs():void
		{
			const future:Future = instantSuccess()
				
			future.onCompleted(async.add(emptyCallback))
			future.onCancelled(failCallback)
		}
		
		[Test]
		public function testSuccessArgs():void
		{
			const future:Future = instantSuccess('arg', [1 ,2])
			
			future.onCompleted(async.add(function (a:String, b:Array):void {
			}))
			
			future.onCancelled(failCallback)
		}
		
		[Test(expects="ArgumentError")]
		public function testSuccessWrongListenerSigniture():void
		{
			const future:Future = instantSuccess('arg', [1 ,2])
			
			future.onCompleted(function (a:String):void {
			})
			
			future.onCancelled(failCallback)
		}
		
		[Test]
		public function testSuccessAndThen_Map():void
		{
			futureASuccess
				.andThen(function (resultA:String):Future {					
					return futureBSuccess
						.mapComplete(function (resultB:String):String {
							return resultB + "mapped" 
						})
				})
		}
		
		
		[Test]
		public function testSuccessAndThenDepthOne():void
		{
			futureASuccess
				.andThen(function (resultA:String):Future {
					return futureBSuccess
				})
					
			futureASuccess.onCompleted(async.add(function (result:String):void {
				assertEquals(argBSuccess, result)
			}))
		}
		
		[Test]
		public function testSuccessAndThenDepthTwo():void
		{
			futureASuccess
				.andThen(function (resultA:String):Future {
					return futureBSuccess.andThen(function (resultB:String):Future {
						return futureCSuccess
					})
				})
			
				futureASuccess.onCancelled(buildFail("futureA can never fail, it's a sequence of instantSuccess Futures"))
					
				futureASuccess.onCompleted(async.add(function (result:String):void {
					assertEquals(argCSuccess, result)
				}))
		}
		
		[Test]
		public function testSuccessOrThenDepthTwo_TerminationAtDepthOne():void
		{
			futureASuccess
				.orThen(function (resultA:String):Future {
					return futureBSuccess.orThen(function (resultB:String):Future {
						return futureCSuccess
					})
				})
			
			futureASuccess.onCancelled(buildFail("futureA can never fail, it's a sequence of instantSuccess Futures"))
			
			futureASuccess.onCompleted(async.add(function (result:String):void {
				assertEquals(argASuccess, result)
			}))
		}
		
		[Test]
		public function testSuccessOrThenDepthTwo_TerminationAtDepthOneWithLeadingAndThen():void
		{
			futureASuccess
				.orThen(function (resultA:String):Future {
					return futureBSuccess.andThen(function (resultB:String):Future {
						return futureCSuccess
					})
				})
			
			futureASuccess.onCancelled(buildFail("futureA can never fail, it's a sequence of instantSuccess Futures"))
			
			futureASuccess.onCompleted(async.add(function (result:String):void {
				assertEquals(argASuccess, result)
			}))
		}
		
		[Test]
		public function testSuccessOrThenDepthTwo_TerminationAtDepthTwo():void
		{
			futureASuccess
				.andThen(function (resultA:String):Future {
					return futureBSuccess.orThen(function (resultB:String):Future {
						return futureCSuccess
					})
				})
			
			futureASuccess.onCancelled(buildFail("futureA can never fail, it's a sequence of instantSuccess Futures"))
			
			futureASuccess.onCompleted(async.add(function (result:String):void {
				assertEquals(argBSuccess, result)
			}))
		}
		
		[Test(expects="ArgumentError")]
		public function testFailWrongListenerSigniture():void
		{
			const future:Future = instantFail('arg', [1 ,2])
			
			future.onCompleted(failCallback)
			future.onCancelled(function (a:String):void {})
		}
		
		[Test]
		public function testFailNoArgs():void
		{
			const future:Future = instantFail()
			
			future.onCompleted(failCallback)
			future.onCancelled(async.add(emptyCallback))
		}
		
		[Test]
		public function testFailArgs():void
		{
			const future:Future = instantFail('arg', [1, 2])
			
			future.onCompleted(failCallback)
			future.onCancelled(async.add(function (a:String, b:Array):void {}))
		}
		
		[Test]
		public function testFailAndThenDepthOne():void
		{
			futureAFail
				.orThen(function (resultA:String):Future {
					return futureBFail
				})
			
			futureAFail.onCompleted(buildFail("futureA can never succeed, it's a sequence of instantFail Futures"))
				
			futureAFail.onCancelled(async.add(function (result:String):void {
				assertEquals(argBFail, result)
			}))
		}
		
		[Test]
		public function testFailOrThenDepthTwo_FailChain():void
		{
			futureAFail
				.orThen(function (resultA:String):Future {
					return futureBFail.orThen(function (resultB:String):Future {
						return futureCFail
					})
				})
			
			futureAFail.onCompleted(buildFail("futureA can never succeed, it's a sequence of instantFail Futures"))
			
			futureAFail.onCancelled(async.add(function (result:String):void {
				assertEquals(argCFail, result)
			}))
		}
		
		[Test]
		public function testFailAndThenDepthTwo_FailAtDepthOne():void
		{
			futureAFail
				.andThen(function (resultA:String):Future {
					return futureBFail.andThen(function (resultB:String):Future {
						return futureCFail
					})
				})
			
			futureAFail.onCompleted(buildFail("futureA can never succeed, it's a sequence of instantFail Futures"))
			
			futureAFail.onCancelled(async.add(function (result:String):void {
				assertEquals(argAFail, result)
			}))
		}
		
		[Test]
		public function testFailAndThenDepthTwo_FailAtDepthTwo():void
		{
			futureAFail
				.orThen(function (resultA:String):Future {
					return futureBFail.andThen(function (resultB:String):Future {
						return futureCFail
					})
				})
			
			futureAFail.onCompleted(buildFail("futureA can never succeed, it's a sequence of instantFail Futures"))
			
			futureAFail.onCancelled(async.add(function (result:String):void {
				assertEquals(argBFail, result)
			}))
		}
	}
}