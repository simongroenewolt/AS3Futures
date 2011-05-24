package org.osflash.futures
{
	/**
	 * When two or more Futures needs to synchonise in time this is the class that manages that 
	 */	
	public class SyncedFuture extends TypedFuture implements Future
	{
		protected var
			futuresToSync:Array = [],
			isCancelled:Boolean = false
				
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
			forEachChildFuture(function (childFuture:Future):void {
				
				childFuture.onCompleted(function (...args):void {
					completesReceived++
					
					// find the future in the list
					for (i=0; i<futuresToSync.length; ++i)
					{
						var blob:Object = futuresToSync[i]
						
						// associate it with the arguements 
						if (blob.future == childFuture)
						{
							blob.args = args
						}
					}
					
					if (completesReceived == futuresToSync.length)
					{
						// make one array from all the arguments received, in the order the futures were registered in 
						var argsComposite:Array = []
						
						forEachChildFuture(function (cf:Future, argsSaved:Array):void {
							argsComposite = argsComposite.concat(argsSaved)
						})
						
						// collect the args from each
						complete.apply(null, argsComposite)
					}
				})
				
				childFuture.onCancelled(function (...args):void {
					cancelThis(childFuture, args)
				})
			})
		}
		
		protected function cancelThis(futureThatCancelled:Future, args:Array):void
		{
			// old school boolean lock, a SyncedFuture should only be cancelled once
			if (isCancelled == false)
			{
				isCancelled = true
					
				forEachChildFuture(function (childFuture:Future):void {
					// only cancel a child future if it is not the child that just cancelled
					if (childFuture != futureThatCancelled && childFuture.isPast == false)
						childFuture.cancel.apply(null, args)
				})
				
				cancel.apply(null, args)
			}
		}
		
		protected function forEachChildFuture(f:Function):void 
		{
			var i:int
			
			// if function has one argument then pass in the future
			if (f.length == 1)
			{
				for (i=0; i<futuresToSync.length; ++i)
				{
					const childFuture:Future = futuresToSync[i].future
					f(childFuture)
				}
			}
			// if function has two arguments then pass in the future and it's saved args
			else if (f.length == 2)
			{
				for (i=0; i<futuresToSync.length; ++i)
				{
					f(futuresToSync[i].future, futuresToSync[i].args)
				}
			}
		}
		
		override public function dispose():void
		{
			for each (var blob:Object in futuresToSync)
			{
				const future:Future = blob.future
				future.dispose()
			}
		}
		
		public function sync(...otherFutures):Future
		{
			return new SyncedFuture(futuresToSync.concat(otherFutures))
		}
	}
}