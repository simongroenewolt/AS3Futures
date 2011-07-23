package org.osflash.futures.creation
{
	import org.osflash.futures.IFuture;
	import org.osflash.futures.support.assertFutureIsAlive;

	/**
	 * When two or more Futures needs to synchonise in time this is the class that manages that
	 * if all children succeed before listeners attach
	 * if one child fails before listeners attach 
	 */
	public class SyncedFuture extends Future
	{
		protected var
			argsTotal:Array = [],
			completesReceived:int = 0,
			isCancelled:Boolean
				
		protected const
			futuresToSync:Array = []
				
		public function SyncedFuture(name:String, syncThese:Array)
		{
			super(name)
			var i:int=0
				
			// we want to store the future in an 2-tuple object so we can easily associate arguments that come in from complete callback later
			for (; i<syncThese.length; ++i)
			{
				futuresToSync.push({
					future: syncThese[i],
					args: []
				})
			}
			
			// if any of the sub-futures are cancelled then cancel this future and dispose of them all
			// attach complete listener to each future
			forEachChildFuture(function (childFuture:IFuture):void {
				assertFutureIsAlive(childFuture, 'Caught attempt to sync with a dead future')
				
				childFuture.onComplete(buildOnChildComplete(childFuture))
				
				childFuture.onCancel(function (...argsFromChild):void {
					cancelThis(childFuture, argsFromChild)
				})
			})
		}
		
		protected function cancelThis(futureThatCancelled:IFuture, args:Array):void
		{
			if(isCancelled == false)
			{
				isCancelled = true
				forEachChildFuture(function (childFuture:IFuture):void {
					
					// only cancel a child future if it is not the child that just cancelled
					if (childFuture != futureThatCancelled && childFuture.isPast == false)
					{
						childFuture.cancel.apply(null, args)
					}
				})
			
				cancel.apply(null, args)
			}
		}
		
		protected function buildOnChildComplete(childFuture:IFuture):Function
		{
			return function (...args):void {
				completesReceived++
					
				saveArgs(childFuture, args)
				
				if (completesReceived == futuresToSync.length)
				{
					// make one array from all the arguments received, in the order the futures were registered in 
					forEachChildFuture(function (cf:IFuture, argsSaved:Array):void {
						argsTotal = argsTotal.concat(argsSaved)
					})
					
					complete.apply(null, argsTotal)
				}
			}
		}
		
		protected function saveArgs(childFuture:IFuture, args:Array):void 
		{
			var blob:Object
			
			// find the future in the list
			for (var i:int=0; i<futuresToSync.length; ++i)
			{
				blob = futuresToSync[i]
				
				// associate it with the arguements 
				if (blob.future == childFuture)
				{
					blob.args = args
					break
				}
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
					const childFuture:IFuture = futuresToSync[i].future
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
		
		/**
		 * @inheritDoc 
		 */
		override public function dispose():void
		{
			for each (var blob:Object in futuresToSync)
			{
				const future:IFuture = blob.future
				future.dispose()
			}
			
			super.dispose()
		}
	}
}