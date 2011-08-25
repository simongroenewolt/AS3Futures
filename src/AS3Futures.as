package {
    import flash.display.Sprite;
    import flash.events.FullScreenEvent;
    
    import org.osflash.futures.IFuture;
    import org.osflash.futures.creation.Future;
    import org.osflash.futures.creation.FutureTest;
    import org.osflash.futures.creation.instantFail;
    import org.osflash.futures.creation.instantSuccess;
    import org.osflash.futures.creation.timedFail;
    import org.osflash.futures.creation.timedSuccess;
    import org.osflash.futures.creation.waitOnCritical;
    import org.osflash.futures.support.isolate;
    import org.osflash.futures.support.successChain;

    public class AS3Futures extends Sprite 
	{
        public function AS3Futures() 
		{
			const argA:String = 'argA'
			const argB:String = 'argB'
			const argC:String = 'argC'
			
			successChain(
				timedSuccess(1000, 'argA'),
				timedFail(2000, 'argB'),
				timedSuccess(3000, 'argC')
			)
			.onComplete(function (...args):void {
				trace('complete:', args)
			})
			.onCancel(function (...args):void {
				trace('cancel:', args)
			})
			
//			const futureA : IFuture = new FutureTest()	
				
//			const futureA : IFuture = new Future(argA)
//			const futureB : IFuture = new Future(argB)
//			const futureC : IFuture = new Future(argC)	
				
			const futureA:IFuture = timedSuccess(100, argA, argB)
//			const futureB:IFuture = timedSuccess(argB, 1000, argB)
//			const futureC:IFuture = timedSuccess(argC, 1000, argC)
				
//			const futureA:IFuture = timedFail(200, argA)
			const futureB:IFuture = timedFail(200, argB)
//			const futureC:IFuture = timedFail(200, argC)
				
//			const futureA:IFuture = instantFail(argA, argA)
//			const futureB:IFuture = instantFail(argB, argB)
//			const futureC:IFuture = instantSuccess(argC, argC)
			
//			producer()
				
			// producer
//			futureA
//				.orThen(function (argA:String):IFuture {
//					return instantSuccess(argB, argB)
//						.mapComplete(function (argB:String):Array {
//							return [argA, argB]
//						})
//				})
//					
//			futureA
//				.orThen (argA:String) => 
//					instantSuccess(argB, argB)
//						.mapComplete (argB:String) => [argA, argB]
				
//			const futureA:IFuture = waitOnCritical(
//				'futureA',
//				instantSuccess(argA, argA),
//				instantFail(argB, argB).orElseCompleteWith(<default/>),
//				instantSuccess(argC, argC)
//			)
			
			// client 		
//			futureA.onComplete(function (argA:String, argB:String, argC:String):void {
				
//			futureA.complete(argA, argB)
					
//			const futureA:IFuture = instantFail(argA, argB)
//			const futureB:IFuture = instantFail(argB)
//			const futureC:IFuture = instantFail(argC)
				
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
		
		protected function producer():IFuture
		{
			return isolate(
				timedSuccess(1000, 'argA', 'argB')
					.onComplete(onABComplete)
					.onCancel(onABCancel)
			)
			
			function onABComplete(...args):IFuture {
				trace('AB onComplete:', args)
				return timedSuccess(1000, 'argC')
					.onComplete(onCComplete)
					.onCancel(onCCancel)
				
				function onCComplete(arg:String):IFuture {
					trace('C onComplete:', arg)
					return timedSuccess(1000, 'argC')
				}
				
				function onCCancel(...args):void {
					trace('C onCancel:', args)
				}
					
			}
			
			function onABCancel(...args):void {
				trace('AB onCancel:', args)
			}
		}
    }
}

