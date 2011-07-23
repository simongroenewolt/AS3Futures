package org.osflash.futures
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.assertMatches;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	public class FuturesTestBase
	{
		[Inject]
		public var asyncManager:IAsync
		
		public var asyncTimeout:int = 30
		
		protected function async(f:Function):Function {
			return asyncManager.add(f, asyncTimeout)
		}	
			
		protected const
			argASuccess:String = 'argASuccss',
			argBSuccess:String = 'argBSuccess',
			argCSuccess:String = 'argCSuccess',
			argAFail:String = 'argAFail',
			argBFail:String = 'argBFail',
			argCFail:String = 'argCFail'
		
		protected var buildFutureSuccess:Function = function (...args):IFuture {
			throw new Error('implment buildFutureSuccess')
		}
			
		protected var buildFutureFail:Function = function (...args):IFuture {
			throw new Error('implment buildFutureFail')
		}
			
		protected var
			futureA:IFuture, 
			futureB:IFuture,
			futureC:IFuture
		
		protected const 
			emptyCallback:Function = function (...args):void {},
			failCallback:Function = function (...args):void { fail() };
			
		protected function buildFail(message:String):Function
		{
			return function (...args):void { fail(message) }
		}
		
		[After]
		public function dispose():void
		{
//			futureA.dispose()
//			futureB.dispose()
//			futureC.dispose()
		}
		
//		[Test]
//		public function map_AndThen():void
//		{
//			futureA
//				.mapComplete(function (resultA:String):String {
//					return resultA + "mapped"
//				})
//				.andThen(async(function (resultA:String):Future {
//					assertMatches(/^argA\w*mapped/, resultA)
//					return futureB
//				}))
//					
//			futureA.onComplete(async(function (result:String):void {
//				assertMatches(/^argB/, result)
//			}))
//		}
	}
}