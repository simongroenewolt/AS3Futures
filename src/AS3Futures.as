package {
    import flash.display.Sprite;
    
    import org.osflash.futures.Future;
    import org.osflash.futures.TypedFuture;
    import org.osflash.futures.waitOnCritical;

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			
			const futureA:Future = new TypedFuture()
				.orElseCompleteWith('orElse')
				.onCompleted(function (message:String):void {
					trace('onCompleted:', message)
				})
//				.onCancelled(function (message:String):void {
//					trace('onCancelled:', message)
//				})
			
//			futureA.complete('complete baby!')
			futureA.cancel('cancel baby!')
			
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

