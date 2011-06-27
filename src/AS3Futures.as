package {
    import flash.display.Sprite;
    
    import org.osflash.futures.Future;
    import org.osflash.futures.creation.TypedFuture;
    import org.osflash.futures.creation.instantFail;
    import org.osflash.futures.creation.instantSuccess;
    import org.osflash.futures.creation.timedFail;
    import org.osflash.futures.creation.timedSuccess;
    import org.osflash.futures.creation.waitOnCritical;
    import org.osflash.futures.support.BaseFuture;

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
				
			const futureA:Future = new TypedFuture()
			const futureB:Future = new TypedFuture()
			const futureC:Future = new TypedFuture()	
				
//			const futureA:Future = timedSuccess(2000, argA)
//			const futureB:Future = timedSuccess(2000, argB)
//			const futureC:Future = timedSuccess(2000, argC)
				
//			const futureA:Future = timedFail(200, argA)
//			const futureB:Future = timedFail(200, argB)
//			const futureC:Future = timedFail(200, argC)
				
//			const futureA:Future = instantSuccess(argA)
//			const futureB:Future = instantSuccess(argB)
//			const futureC:Future = instantSuccess(argC)
				
//			const futureA:Future = instantFail(argA)
//			const futureB:Future = instantFail(argB)
//			const futureC:Future = instantFail(argC)
				
//			const compound:Future = futureA.waitOnCritical(futureB).waitOnCritical(futureC)
			
//			const compound:Future = waitOnCritical(futureA, futureB)
//				
//			compound.onCompleted(function (resultA:String, resultB:String):void {
//				trace('ONCOMPLETE:', resultA, resultB)
//			})
//				
//			compound.onCancelled(function (result:String):void {
//				trace('ONCANCEL:', result)
//			})	
				
			futureA
				.andThen(function (resultA:String):Future {
					return futureB
						.orThen(function (resultB:String):Future {
							return futureC
						})
				})	
				
				
			futureA.onCompleted(function (...args):void { trace('completed:', args) } )
			futureA.onCancelled(function (...args):void { trace('cancelled:', args) } )
				
			futureA.complete(argA)
			futureB.complete(argB)
				
//			const compound:Future = futureA.waitOnCritical(
//				futureB
//				// .mapComplete(function (resultB:String):String {
//				// return resultB + "mapped"
//				// })
//			)
				
//			compound.onCompleted(function (...args):void {
//				trace('args:', args)
//			})	
        }
    }
}

