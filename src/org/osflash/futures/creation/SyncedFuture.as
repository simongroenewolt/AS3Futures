package org.osflash.futures.creation
{
	import org.osflash.functional.applyArgs;
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
			completesReceived:int = 0
				
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
			forEachChildFuture(function (childFuture:Future):void {
				assertFutureIsAlive(childFuture, 'Caught attempt to sync with a dead future')
				
				childFuture.internal::afterComplete(buildOnChildComplete(childFuture))
				
				childFuture.internal::afterCancel(function (...argsFromChild):void {
					applyArgs(cancel, argsFromChild)
				})
			})
		}
		
		override public function complete(...args):void
		{
			applyArgs(super.complete, args)
			
			forEachChildFuture(function (childFuture:Future):void {
				applyArgs(childFuture.complete, args)
			})
		}
		
		override public function cancel(...args):void
		{ 
			if(cancelling == false)
			{
				applyArgs(super.cancel, args)
				
				forEachChildFuture(function (childFuture:Future):void {
					
					// only cancel a child future if it is not the child that just cancelled
					if (childFuture.isPast == false)
					{
						applyArgs(childFuture.cancel, args)
					}
				})
			}
		}
		
		protected function buildOnChildComplete(childFuture:Future):Function
		{
			return function (...args):void {
				completesReceived++
					
				saveArgs(childFuture, args)
				
				if (completesReceived == futuresToSync.length)
				{
					// make one array from all the arguments received, in the order the futures were registered in 
					forEachChildFuture(function (cf:Future, argsSaved:Array):void {
						argsTotal = argsTotal.concat(argsSaved)
					})
					
					complete.apply(null, argsTotal)
				}
			}
		}
		
		protected function saveArgs(childFuture:Future, args:Array):void 
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
		
		/**
		 * @inheritDoc 
		 */
		override public function dispose():void
		{
			for each (var blob:Object in futuresToSync)
			{
				const future:Future = blob.future
				future.dispose()
			}
			
			super.dispose()
		}
	}
}