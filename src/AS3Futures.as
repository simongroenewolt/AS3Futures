package {
    import flash.display.Sprite;
	import org.osflash.futures.TypedFuture

    public class AS3Futures extends Sprite {

        public function AS3Futures() {
			const future:TypedFuture = new TypedFuture()
			
			future.complete('moo')
        }
    }
}

