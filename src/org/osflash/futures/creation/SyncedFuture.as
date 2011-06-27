package org.osflash.futures.creation
{
	import org.osflash.futures.Future;
	import org.osflash.futures.FutureProgressable;
	import org.osflash.futures.support.BaseFuture;
	import org.osflash.futures.support.InstantFuture;
	import org.osflash.futures.support.assertFutureIsAlive;

	/**
	 * When two or more Futures needs to synchonise in time this is the class that manages that
	 * if all children succeed before listeners attach
	 * if one child fails before listeners attach 
	 */	
	public class SyncedFuture implements FutureProgressable
	{
		protected var
			// if the sync is satisfied on start up then it should act like an InstantFuture (Success or Fail depending if all children Futures succeded or one cancelled)
			// Otherwise the sync acts like a BaseFuture
			futureBehvaiour:BaseFuture,
			completesReceived:int = 0,
			setupComplete:Boolean = false,
			isCancelled:Boolean = false,
			allChildrenSuccededAtStartup:Boolean = false,
			childCancelledAtStartup:Boolean = false,
			argsTotal:Array = []
				
		protected const
			futuresToSync:Array = []
//			isCancelled:Boolean = false
				
		public function SyncedFuture(syncThese:Array)
		{
			var i:int=0
				
			// we want to store the future in an 2-tuple object so we can easily associate arguments that come in from complete callback later
			for (; i<syncThese.length; ++i)
			{
				futuresToSync.push({
					future: syncThese[i],
					args: []
				})
			}
			
			// startup could result in the sync being satisfied so we need to track this
			var childFuture:Future // enumeration variable
			
			// if any of the sub-futures are cancelled then cancel this future and dispose of them all
			// attach complete listener to each future
			// if any child cancels then stop setting up and make the behaviour of this Future like an InstantFutureFail
			for (i=0; i<futuresToSync.length && childCancelledAtStartup == false; ++i)
			{
				childFuture = futuresToSync[i].future
					
				assertFutureIsAlive(childFuture, 'Caught attempt to sync with a dead future')
				
				childFuture.onCompleted(buildOnChildComplete(childFuture))
				
				childFuture.onCancelled(function (...argsFromChild):void {
					if(setupComplete)
					{
						cancelThis(childFuture, argsFromChild)
					}
					else
					{
						childCancelledAtStartup = true
						argsTotal = argsFromChild
					}
				})
			}	
			
			if (allChildrenSuccededAtStartup)
			{
				futureBehvaiour = new InstantFutureSuccess(argsTotal)
			}
			else if (childCancelledAtStartup)
			{
				futureBehvaiour = new InstantFutureFail(argsTotal)
			}
			else
			{
				futureBehvaiour = new BaseFuture()
			}
			
			setupComplete = true
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
					
					if (setupComplete)
						complete.apply(null, argsTotal)
					else
						allChildrenSuccededAtStartup = true
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
		
		protected function cancelThis(futureThatCancelled:Future, args:Array):void
		{
			if(isCancelled == false)
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
		
		public function dispose():void
		{
			for each (var blob:Object in futuresToSync)
			{
				const future:Future = blob.future
				future.dispose()
			}
			
			futureBehvaiour.dispose()
		}
		
		public function sync(...otherFutures):Future
		{
			return new SyncedFuture(futuresToSync.concat(otherFutures))
		}
		
		public function get isPast():Boolean
		{
			return futureBehvaiour.isPast
		}
		
		public function onCompleted(f:Function):Future
		{
			return futureBehvaiour.onCompleted(f)
		}
		
		public function complete(...args):void
		{
			futureBehvaiour.complete.apply(null, args)
		}
		
		public function mapComplete(funcOrObject:Object):Future
		{
			return futureBehvaiour.mapComplete(funcOrObject)
		}
		
		public function onCancelled(f:Function):Future
		{
			return futureBehvaiour.onCancelled(f)
		}
		
		public function cancel(...args):void
		{
			futureBehvaiour.cancel.apply(null, args)
		}
		
		public function mapCancel(funcOrObject:Object):Future
		{
			return futureBehvaiour.mapCancel(funcOrObject)	
		}
		
		public function andThen(f:Function):Future
		{
			return futureBehvaiour.andThen(f)	
		}		
		
		public function orThen(f:Function):Future
		{
			return futureBehvaiour.orThen(f)
		}
		
		public function orElseCompleteWith(funcOrObject:Object):Future
		{
			return futureBehvaiour.orElseCompleteWith(funcOrObject)
		}
		
		public function waitOnCritical(...otherFutures):Future
		{
			return futureBehvaiour.waitOnCritical.apply(null, otherFutures)
		}
		
		public function onProgress(callback:Function):FutureProgressable // unit:Number
		{
			return futureBehvaiour.onProgress(callback)
		}
		
		public function progress(unit:Number):void
		{
			FutureProgressable(futureBehvaiour).progress(unit)
		}
	}
}