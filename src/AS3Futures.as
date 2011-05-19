package {
    import flash.display.Sprite;
    
    import org.osflash.futures.TypedFuture;

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			const future:TypedFuture = new TypedFuture()
			
			future.onCompleted(function (message:String):void {
				trace('0:', message)
			})
				
			future.onCancelled(function (message:String):void {
				trace('1:', message)
			})
				
//			future.complete('moo')
			future.cancel('moo')
        }
    }
}

