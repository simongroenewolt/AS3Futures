package org.osflash.futures 
{
	import asunit.framework.IAsync;
	
	import org.osflash.futures.creation.TypedFuture;

	public class TypedFutureSuccessTests extends FuturesTestBase
	{
		[Before]
		public function setup():void 
		{
			futureA = new FutureProxy(new TypedFuture(), function (future:Future):void { future.complete(argASuccess) })
			futureB = new FutureProxy(new TypedFuture(), function (future:Future):void { future.complete(argBSuccess) })
			futureC = new FutureProxy(new TypedFuture(), function (future:Future):void { future.complete(argCSuccess) })
		}
		
		[Test]
		public function shouldCompleteWithTyping():void
		{
			const future:Future = new TypedFuture([String, Array])
				
			future.onCompleted(async(function (a:String, b:Array):void {
				
			}))
				
			future.complete('arg', [1, 2])
		}
		
		[Test]
		public function shouldCompleteWithoutTyping():void
		{
			const future:Future = new TypedFuture()
			
			future.onCompleted(async(function (a:String, b:Array):void {
				
			}))
			
			future.complete('arg', [1, 2])
		}
		
		[Test(expects="ArgumentError")]
		public function shouldFailDueToBadListenerSigniture():void
		{
			const future:Future = new TypedFuture([String, Array])
			
			future.onCompleted(function (a:String):void {
				
			})
		}
		
		[Test(expects="ArgumentError")]
		public function shouldFailDueToInvalidCompleteArguments():void
		{
			const future:Future = new TypedFuture([String, Array])
			
			future.onCompleted(function (a:String, b:Array):void {
				
			})
				
			future.complete('arg')
		}
	}
}