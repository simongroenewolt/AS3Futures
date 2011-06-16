package {
    import flash.display.Sprite;
    
    import org.osflash.futures.Future;
    import org.osflash.futures.TypedFuture;
    import org.osflash.futures.instantSuccess;
    import org.osflash.futures.waitOnCritical;

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			
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
					
			futureA.onCompleted(trace)
				
//			const argA:String = 'argA'
//			const argB:String = 'argB'
//			const argC:String = 'argC'
//			const futureA:Future = instantSuccess(argA)
//			const futureB:Future = instantSuccess(argB)
//			const futureC:Future = instantSuccess(argC)
//			
//			futureA
//				.andThen(function (resultA:String):Future {
//					return futureB.andThen(function (resultB:String):Future {
//						return futureC
//					})
//				})
//			
//			futureA.onCompleted(function (result:String):void {
//				trace(result)
//			})
			
//			const futureC:Future = new TypedFuture()
//				.mapComplete(function (message:String):String {
//					return message + ' mapped complete'
//				})
//				.mapCancel(function (message:String):String {
//					return message + ' mapped cancel'
//				})
//				.onCompleted(trace)
//				.onCancelled(trace)
//			
//			const futureB:Future = new TypedFuture()
//				.andThen(function (bResult:String):Future {
//					return futureC
//				})
//				
//			
//			const futureA:Future = instantSuccess('moo')
//				.andThen(function (aResult:String):Future {
//					return futureB 
//				})
//			
//			futureA
//				.onCompleted(trace)
//				.onCancelled(trace)
				
//			futureA.complete('complete A!')	
//			futureA.cancel('cancel baby!')
//			futureB.complete('complete B!')
//			futureB.cancel('cancel B')
//			futureC.complete('complete C!')
//			futureC.cancel('complete C!')
			
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

