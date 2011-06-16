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
			emptyCallback:Function = function ():void {},
			failCallback:Function = function ():void { fail() };
		
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
			const argA:String = 'argA'
			const argB:String = 'argB'
			const futureA:Future = instantSuccess(argA)
			const futureB:Future = instantSuccess(argB)
				
			futureA
				.andThen(function (resultA:String):Future {					
					return futureB
						.mapComplete(function (resultB:String):String {
							return resultB + "mapped" 
						})
				})
		}
		
		
		[Test]
		public function testSuccessAndThenDepthOne():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const futureA:Future = instantSuccess(argA)
			const futureB:Future = instantSuccess(argB)
				
			futureA
				.andThen(function (resultA:String):Future {
					return futureB
				})
					
			futureA.onCompleted(async.add(function (result:String):void {
				assertEquals(argB, result)
			}))
		}
		
		[Test]
		public function testSuccessAndThenDepthTwo():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			const futureA:Future = instantSuccess(argA)
			const futureB:Future = instantSuccess(argB)
			const futureC:Future = instantSuccess(argC)
			
			futureA
				.andThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
				futureA.onCancelled(function (...args):void {
					fail("futureA can never fail, it's a sequence of instantSuccess Futures")
				})
					
				futureA.onCompleted(async.add(function (result:String):void {
					assertEquals(argC, result)
				}))
		}
		
		[Test]
		public function testSuccessOrThenDepthTwo_TerminationAtDepthOne():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			const futureA:Future = instantSuccess(argA)
			const futureB:Future = instantSuccess(argB)
			const futureC:Future = instantSuccess(argC)
			
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.orThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCancelled(function (...args):void {
				fail("futureA can never fail, it's a sequence of instantSuccess Futures")
			})
			
			futureA.onCompleted(async.add(function (result:String):void {
				assertEquals(argA, result)
			}))
		}
		
		[Test]
		public function testSuccessOrThenDepthTwo_TerminationAtDepthOneWithLeadingAndThen():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			const futureA:Future = instantSuccess(argA)
			const futureB:Future = instantSuccess(argB)
			const futureC:Future = instantSuccess(argC)
			
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCancelled(function (...args):void {
				fail("futureA can never fail, it's a sequence of instantSuccess Futures")
			})
			
			futureA.onCompleted(async.add(function (result:String):void {
				assertEquals(argA, result)
			}))
		}
		
		[Test]
		public function testSuccessOrThenDepthTwo_TerminationAtDepthTwo():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			const futureA:Future = instantSuccess(argA)
			const futureB:Future = instantSuccess(argB)
			const futureC:Future = instantSuccess(argC)
			
			futureA
				.andThen(function (resultA:String):Future {
					return futureB.orThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCancelled(function (...args):void {
				fail("futureA can never fail, it's a sequence of instantSuccess Futures")
			})
			
			futureA.onCompleted(async.add(function (result:String):void {
				assertEquals(argB, result)
			}))
		}
		
		[Test(expects="ArgumentError")]
		public function testFailWrongListenerSigniture():void
		{
			const future:Future = instantFail('arg', [1 ,2])
			
			future.onCompleted(failCallback)
			future.onCancelled(function (a:String):void {
			})
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
			future.onCancelled(async.add(function (a:String, b:Array):void {
			}))
		}
		
		[Test]
		public function testFailAndThenDepthOne():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const futureA:Future = instantFail(argA)
			const futureB:Future = instantFail(argB)
			
			futureA
				.orThen(function (resultA:String):Future {
					return futureB
				})
			
			futureA.onCompleted(function (...args):void {
				fail("futureA can never succeed, it's a sequence of instantFail Futures")
			})
				
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argB, result)
			}))
		}
		
		[Test]
		public function testFailOrThenDepthTwo_FailChain():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			const futureA:Future = instantFail(argA)
			const futureB:Future = instantFail(argB)
			const futureC:Future = instantFail(argC)
			
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.orThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCompleted(function (...args):void {
				fail("futureA can never succeed, it's a sequence of instantFail Futures")
			})
			
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argC, result)
			}))
		}
		
		[Test]
		public function testFailAndThenDepthTwo_FailAtDepthOne():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			const futureA:Future = instantFail(argA)
			const futureB:Future = instantFail(argB)
			const futureC:Future = instantFail(argC)
			
			futureA
				.andThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCompleted(function (...args):void {
				fail("futureA can never succeed, it's a sequence of instantFail Futures")
			})
			
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argA, result)
			}))
		}
		
		[Test]
		public function testFailAndThenDepthTwo_FailAtDepthTwo():void
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			const futureA:Future = instantFail(argA)
			const futureB:Future = instantFail(argB)
			const futureC:Future = instantFail(argC)
			
			futureA
				.orThen(function (resultA:String):Future {
					return futureB.andThen(function (resultB:String):Future {
						return futureC
					})
				})
			
			futureA.onCompleted(function (...args):void {
				fail("futureA can never succeed, it's a sequence of instantFail Futures")
			})
			
			futureA.onCancelled(async.add(function (result:String):void {
				assertEquals(argB, result)
			}))
		}
	}
}