package org.osflash.futures 
{
	import asunit.framework.IAsync;
	import org.osflash.futures.creation.TypedFuture;

	public class TypedFutureTests 
	{
		[Inject]
		public var async:IAsync
		
		[Test]
		public function shouldCompleteWithTyping():void
		{
			const future:Future = new TypedFuture([String, Array])
				
			future.onCompleted(async.add(function (a:String, b:Array):void {
				
			}))
				
			future.complete('arg', [1, 2])
		}
		
		[Test]
		public function shouldCompleteWithoutTyping():void
		{
			const future:Future = new TypedFuture()
			
			future.onCompleted(async.add(function (a:String, b:Array):void {
				
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