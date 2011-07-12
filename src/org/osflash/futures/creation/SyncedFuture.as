package org.osflash.futures.creation
{
	import org.osflash.futures.Future;
	import org.osflash.futures.IFuture;
	import org.osflash.futures.support.BaseFuture;
	import org.osflash.futures.support.InstantFuture;
	import org.osflash.futures.support.assertFutureIsAlive;

	/**
	 * When two or more Futures needs to synchonise in time this is the class that manages that
	 * if all children succeed before listeners attach
	 * if one child fails before listeners attach 
	 */	
	public class SyncedFuture implements IFuture
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
			var childFuture:IFuture // enumeration variable
			
			// if any of the sub-futures are cancelled then cancel this future and dispose of them all
			// attach complete listener to each future
			// if any child cancels then stop setting up and make the behaviour of this Future like an InstantFutureFail
			for (i=0; i<futuresToSync.length && childCancelledAtStartup == false; ++i)
			{
				childFuture = futuresToSync[i].future
					
				assertFutureIsAlive(childFuture, 'Caught attempt to sync with a dead future')
				
				childFuture.onComplete(buildOnChildComplete(childFuture))
				
				childFuture.onCancel(function (...argsFromChild):void {
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
		
		/**
		 * @inheritDoc
		 */
		public function isolate():IFuture
		{
			return new Future()
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
					
					if (setupComplete)
						complete.apply(null, argsTotal)
					else
						allChildrenSuccededAtStartup = true
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
		
		protected function cancelThis(futureThatCancelled:IFuture, args:Array):void
		{
			if(isCancelled == false)
			{
				isCancelled = true
					
				forEachChildFuture(function (childFuture:IFuture):void {
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
		public function dispose():void
		{
			for each (var blob:Object in futuresToSync)
			{
				const future:IFuture = blob.future
				future.dispose()
			}
			
			futureBehvaiour.dispose()
		}
		
		/**
		 * @inheritDoc 
		 */
		public function sync(...otherFutures):IFuture
		{
			return new SyncedFuture(futuresToSync.concat(otherFutures))
		}
		
		/**
		 * @inheritDoc 
		 */
		public function get isPast():Boolean
		{
			return futureBehvaiour.isPast
		}
		
		/**
		 * @inheritDoc 
		 */
		public function onComplete(f:Function):IFuture
		{
			return futureBehvaiour.onComplete(f)
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get hasCompleteListener():Boolean
		{
			return futureBehvaiour.hasCompleteListener
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function get completedListeners():int
		{
			return futureBehvaiour.completedListeners
		}
		
		/**
		 * @inheritDoc 
		 */
		public function complete(...args):void
		{
			futureBehvaiour.complete.apply(null, args)
		}
		
		/**
		 * @inheritDoc 
		 */
		public function mapComplete(funcOrObject:Object):IFuture
		{
			return futureBehvaiour.mapComplete(funcOrObject)
		}
		
		/**
		 * @inheritDoc 
		 */
		public function onCancel(f:Function):IFuture
		{
			return futureBehvaiour.onCancel(f)
		}
		
		public function get hasProgressListener():Boolean
		{
			return futureBehvaiour.hasProgressListener
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get hasCancelListener():Boolean
		{
			return futureBehvaiour.hasCancelListener
		}
		
		/**
		 * @inheritDoc 
		 */			
		public function get cancelledListeners():int
		{
			return futureBehvaiour.cancelledListeners
		}
		
		/**
		 * @inheritDoc 
		 */
		public function cancel(...args):void
		{
			futureBehvaiour.cancel.apply(null, args)
		}
		
		/**
		 * @inheritDoc 
		 */
		public function mapCancel(funcOrObject:Object):IFuture
		{
			return futureBehvaiour.mapCancel(funcOrObject)	
		}
		
		/**
		 * @inheritDoc 
		 */
		public function andThen(f:Function):IFuture
		{
			return futureBehvaiour.andThen(f)	
		}		
		
		/**
		 * @inheritDoc 
		 */
		public function orThen(f:Function):IFuture
		{
			return futureBehvaiour.orThen(f)
		}
		
		/**
		 * @inheritDoc 
		 */
		public function orElseCompleteWith(funcOrObject:Object):IFuture
		{
			return futureBehvaiour.orElseCompleteWith(funcOrObject)
		}
		
		/**
		 * @inheritDoc 
		 */
		public function waitOnCritical(...otherFutures):IFuture
		{
			return futureBehvaiour.waitOnCritical.apply(null, otherFutures)
		}
		
		/**
		 * @inheritDoc 
		 */
		public function onProgress(callback:Function):IFuture // unit:Number
		{
			return futureBehvaiour.onProgress(callback)
		}
		
		/**
		 * @inheritDoc 
		 */
		public function progress(unit:Number, ...args):void
		{
			IFuture(futureBehvaiour).progress(unit)
		}
	}
}