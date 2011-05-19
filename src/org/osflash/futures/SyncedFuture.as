package org.osflash.futures
{
	public class SyncedFuture extends TypedFuture implements Future
	{
		protected var
			futuresToSync:Array = []
		
		public function SyncedFuture(syncThese:Array)
		{
			var i:int=0
			// we want to store the future in an object so we can easily associate arguments that come in from complete callback later
			for (; i<syncThese.length; ++i)
			{
				futuresToSync.push({
					future: syncThese[i],
					args: []
				})
			}
			
			var completesReceived:int = 0
			
			// if any of the sub-futures are cancelled then cancel this future and dispose of them all
			// attach complete listener to each future
			futuresToSync.forEach(function (blob:Object, index:int, arr:Array):void {
				const future:Future = blob.future
				
				future.onCompleted(function (...args):void {
					completesReceived++
					
					// find the future in the list
					for (i=0; i<futuresToSync.length; ++i)
					{
						var blob:Object = futuresToSync[i]
						
						if (blob.future == future)
						{
							blob.args = args
						}
					}
					
					if (completesReceived == futuresToSync.length)
					{
						// make one array from all the arguments received, in the order the futures were registered in 
						var argsComposite:Array = []
						
						for (i=0; i<futuresToSync.length; ++i)
						{
							argsComposite = argsComposite.concat(futuresToSync[i].args)
						}
						
						// collect the args from each
						complete.apply(null, argsComposite)
					}
				})
				future.onCancelled(function (...args):void {
					cancel.apply(null, args)
				})
			})
		}
		
		override public function dispose():void
		{
			for each (var blob:Object in futuresToSync)
			{
				blob.future.dispose()
			}
		}
		
		public function sync(...otherFutures):Future
		{
			return new SyncedFuture(futuresToSync.concat(otherFutures))
		}
	}
}