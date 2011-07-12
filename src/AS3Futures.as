package {
    import flash.display.Sprite;
    import flash.events.FullScreenEvent;
    
    import org.osflash.futures.Future;
    import org.osflash.futures.IFuture;
    import org.osflash.futures.creation.TypedFuture;
    import org.osflash.futures.creation.instantFail;
    import org.osflash.futures.creation.instantSuccess;
    import org.osflash.futures.creation.timedFail;
    import org.osflash.futures.creation.timedSuccess;
    import org.osflash.futures.creation.waitOnCritical;
    import org.osflash.futures.support.BaseFuture;
    import org.osflash.futures.support.isolate;

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
				
			const futureA : IFuture = new Future()
			const futureB : IFuture = new Future()
			const futureC : IFuture = new Future()	
				
//			const futureA:IFuture = timedSuccess(100, argA)
//			const futureB:IFuture = timedSuccess(1000, argB)
//			const futureC:IFuture = timedSuccess(1000, argC)
				
//			const futureA:Future = timedFail(200, argA)
//			const futureB:Future = timedFail(200, argB)
//			const futureC:Future = timedFail(200, argC)
				
//			const futureA:Future = instantSuccess(argA)
//			const futureB:Future = instantSuccess(argB)
//			const futureC:Future = instantSuccess(argC)
				
//			const futureA:Future = instantFail(argA)
//			const futureB:Future = instantFail(argB)
//			const futureC:Future = instantFail(argC)
				
			const producer:Function = function ():IFuture
			{
				return isolate(
					futureA
						.onComplete(function (...args):void {
							trace('Producer onComplete:', args)
						})
						.onCancel(function (...args):void {
							trace('Producer onCancel:', args)
						})
				)
			}
				
			const consumer:Function = function ():IFuture
			{
				return IFuture(producer())
					.onComplete(function (...args):void {
						trace('Consumer onComplete:', args)
					})
					.onCancel(function (...args):void {
						trace('Consumer onCancel:', args)
					})
			}
				
			consumer()
//			futureA.complete(argA)
			futureA.onComplete(function (...args):void { trace('completed:', args) } )
			futureA.cancel(argA)
//			futureA.onCancel(function (...args):void { trace('cancelled:', args) } )
				
//			const compound:Future = futureA.waitOnCritical(futureB)
			
//			futureA.andThen(function (resultA:String):IFuture {
//				trace('resultA:', resultA)
//				return waitOnCritical(futureB, futureC)
//					.mapComplete(function (resultB:String, resultC:String):String {
//						trace('resultB:', resultB, 'resultC:', resultC)
//						return resultB + resultC + 'concatenated'
//					})
//			})
				
//			compound.onCompleted(function (result:String):void {
//				trace('ONCOMPLETE:', result)
//			})
//				
//			compound.onCancelled(function (result:String):void {
//				trace('ONCANCEL:', result)
//			})	
			
//			futureA.orElseCompleteWith(<loggingConfig>Moo</loggingConfig>)	
				
//			futureA.complete(argA)
//			futureB.complete(argB)
//			futureA.cancel(argA)
				
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

