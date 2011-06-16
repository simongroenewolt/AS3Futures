package {
    import flash.display.Sprite;
    
    import org.osflash.futures.Future;
    import org.osflash.futures.TypedFuture;
    import org.osflash.futures.waitOnCritical;

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			
			const futureC:Future = new TypedFuture()
			
			const futureB:Future = new TypedFuture()
				.andThen(function (bResult:String):Future {
					return futureC
				})
				
			
			const futureA:Future = new TypedFuture()
				.andThen(function (aResult:String):Future {
					return futureB 
				})
			
			futureA
				.onCompleted(trace)
				.onCancelled(trace)
				
			futureA.complete('complete A!')
			futureB.complete('complete B!')
			futureC.complete('complete C!')
//			futureB.cancel('cancel B')
//			futureA.cancel('cancel baby!')
			
//			const futureA:Future = new TypedFuture()
//			const futureB:Future = new TypedFuture()
//			const futureSync:Future = futureA.waitOnCritical(futureB)
//				.onCompleted(function (messageA:String, messageB:String):void {
//					trace('onComplete:', messageA, messageB)
//				})
//				.onCancelled(function (message:String):void {
//					trace('onCancel:', message)
//				})
//				
//			futureA.complete('A')
//			futureB.cancel('B')
//			future.cancel('moo')
        }
    }
}

