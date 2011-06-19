package org.osflash.futures
{
	import asunit.asserts.assertEquals;
	import asunit.asserts.fail;
	import asunit.framework.IAsync;

	public class FuturesTestBase
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
		
		protected var buildFutureSuccess:Function = function (...args):Future {
			throw new Error('implment buildFutureSuccess')
		}
			
		protected var buildFutureFail:Function = function (...args):Future {
			throw new Error('implment buildFutureFail')
		}
			
		protected var
			futureA:Future, 
			futureB:Future,
			futureC:Future
		
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
			futureA.dispose()
			futureB.dispose()
			futureC.dispose()
		}
	}
}