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
			const future:Future = new InstantFutureSuccess()
				
			future.onCompleted(async.add(emptyCallback))
			future.onCancelled(failCallback)
		}
		
		[Test]
		public function testSuccessArgs():void
		{
			const future:Future = new InstantFutureSuccess('arg', [1 ,2])
			
			future.onCompleted(async.add(function (a:String, b:Array):void {
			}))
			
			future.onCancelled(failCallback)
		}
		
		[Test(expects="ArgumentError")]
		public function testSuccessWrongListenerSigniture():void
		{
			const future:Future = new InstantFutureSuccess('arg', [1 ,2])
			
			future.onCompleted(function (a:String):void {
			})
			
			future.onCancelled(failCallback)
		}
		
		
		[Test(expects="ArgumentError")]
		public function testFailWrongListenerSigniture():void
		{
			const future:Future = new InstantFutureFail('arg', [1 ,2])
			
			future.onCompleted(failCallback)
			future.onCancelled(function (a:String):void {
			})
		}
		
		[Test]
		public function testFailNoArgs():void
		{
			const future:Future = new InstantFutureFail()
			
			future.onCompleted(failCallback)
			future.onCancelled(async.add(emptyCallback))
		}
		
		[Test]
		public function testFailArgs():void
		{
			const future:Future = new InstantFutureFail('arg', [1, 2])
			
			future.onCompleted(failCallback)
			future.onCancelled(async.add(function (a:String, b:Array):void {
			}))
		}
	}
}