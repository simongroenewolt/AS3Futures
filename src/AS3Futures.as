package {
    import flash.display.Sprite;
    import flash.events.FullScreenEvent;
    
    import org.osflash.futures.IFuture;
    import org.osflash.futures.creation.Future;
    import org.osflash.futures.creation.instantFail;
    import org.osflash.futures.creation.instantSuccess;
    import org.osflash.futures.creation.timedFail;
    import org.osflash.futures.creation.timedSuccess;
    import org.osflash.futures.creation.waitOnCritical;
    import org.osflash.futures.support.isolate;

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
				
//			const futureA : IFuture = new Future()
//			const futureB : IFuture = new Future()
//			const futureC : IFuture = new Future()	
				
			const futureA:IFuture = timedSuccess(argA, 100, argA)
//			const futureB:IFuture = timedSuccess(argB, 1000, argB)
//			const futureC:IFuture = timedSuccess(argC, 1000, argC)
				
//			const futureA:IFuture = timedFail(200, argA)
//			const futureB:IFuture = timedFail(200, argB)
//			const futureC:IFuture = timedFail(200, argC)
				
//			const futureA:IFuture = instantSuccess(argA)
//			const futureB:IFuture = instantSuccess(argB)
//			const futureC:IFuture = instantSuccess(argC)
				
//			const futureA:IFuture = instantFail(argA, argB)
//			const futureB:IFuture = instantFail(argB)
//			const futureC:IFuture = instantFail(argC)
				
//			const producer:Function = function ():IFuture
//			{
//				return isolate(
//					futureA
//						.onComplete(function (...args):void {
//							trace('Producer onComplete:', args)
//						})
//						.onCancel(function (...args):void {
//							trace('Producer onCancel:', args)
//						})
//				)
//			}
//				
//			const consumer:Function = function ():IFuture
//			{
//				return IFuture(producer())
//					.onComplete(function (...args):void {
//						trace('Consumer onComplete:', args)
//					})
//					.onCancel(function (...args):void {
//						trace('Consumer onCancel:', args)
//					})
//			}
//				
//			consumer()
			
//			futureA
//				.andThen(function (resultA:String):IFuture {
//					return instantSuccess(argB)
//				})
			
//			const fA:IFuture = waitOnCritical(
//				instantSuccess(argA),
//				instantSuccess(argB),
//				instantSuccess(argC)
//			)
				
//			const futureA:IFuture = waitOnCritical(
//				'futureA',
//				timedFail(argA, 2000, argA),
//				timedFail(argB, 500, argB),
//				timedFail(argC, 10, argC)
//			)
				
//			const futureA:IFuture = instantSuccess(argA)
//				.andThen(function (resultA:String):IFuture {
//					trace('ANDING')
//					return instantSuccess(argB)
//				})
			
			futureA.onComplete(function (argA:String, argB:String):void {
				trace('final complete:')
			})
				
			futureA.onCancel(function (...args):void {
				trace('final cancel:', args)
			})
			
//			futureA.complete(argA)
//			futureA.onComplete(function (...args):void { trace('completed:', args) } )
//			futureA.cancel(argA)
//			futureA.onCancel(function (...args):void { trace('cancelled:', args) } )
				
//			const compound:IFuture = futureA.waitOnCritical(futureB)
			
//			futureA.andThen(function (resultA:String):IFuture {
//				trace('resultA:', resultA)
//				return waitOnCritical(futureB, futureC)
//					.mapComplete(function (resultB:String, resultC:String):String {
//						trace('resultB:', resultB, 'resultC:', resultC)
//						return resultB + resultC + 'concatenated'
//					})
//			})
				
//			compound.onComplete(function (result:String):void {
//				trace('ONCOMPLETE:', result)
//			})
//				
//			compound.onCancel(function (result:String):void {
//				trace('ONCANCEL:', result)
//			})	
			
//			futureA.orElseCompleteWith(<loggingConfig>Moo</loggingConfig>)	
				
//			futureA.complete(argA)
//			futureB.complete(argB)
//			futureA.cancel(argA)
				
//			const compound:IFuture = futureA.waitOnCritical(
//				futureB
//				// .mapComplete(function (resultB:String):String {
//				// return resultB + "mapped"
//				// })
//			)
				
//			compound.onComplete(function (...args):void {
//				trace('args:', args)
//			})	
        }
    }
}

