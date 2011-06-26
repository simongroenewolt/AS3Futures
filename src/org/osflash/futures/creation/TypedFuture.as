package org.osflash.futures.creation
{
	import org.osflash.futures.Future;
	import org.osflash.futures.FutureProgressable;
	import org.osflash.futures.support.BaseFuture;
	import org.osflash.futures.support.ListenerList;
	import org.osflash.futures.support.assertFutureIsAlive;
	import org.osflash.futures.support.assertListenerArguments;

	public class TypedFuture extends BaseFuture implements FutureProgressable
	{
		protected var
			completeTypeList:Array = [],
			cancelTypeList:Array = []	
		
		public function TypedFuture(completeTypes:Array=null, cancelTypes:Array=null)
		{	
			if (completeTypes)	completeTypeList = completeTypes
			if (cancelTypes)	cancelTypeList = cancelTypes
		}
		
		override public function dispose():void
		{
			super.dispose()
			_onProgress.length = 0
		}
		
		override public function onCompleted(f:Function):Future
		{
			assertListenerArguments(f, completeTypeList)
			return super.onCompleted(f)
		}
		
		override public function onCancelled(f:Function):Future
		{
			assertListenerArguments(f, cancelTypeList)
			return super.onCancelled(f)
		}
		
		override protected function dispatchComplete(functionList:Array, args:Array):void
		{
			dispatchTyped(functionList, args, completeTypeList)
		}
		
		override protected function dispatchCancel(functionList:Array, args:Array):void
		{
			dispatchTyped(functionList, args, cancelTypeList)
		}
		
		protected function dispatchTyped(functionList:Array, args:Array, typeList:Array=null):void
		{
			var arg:Object;
			var type:Class;
			const typeAmount:uint = typeList.length;
			if (args.length < typeAmount)
			{
				throw new ArgumentError('Incorrect number of arguments. ' +
					'Expected at least ' + typeAmount + ' but received ' +
					args.length + '.');
			}
			
			for (var i:int = 0; i < typeAmount; i++)
			{
				// null is allowed to pass through.
				if ( (arg = args[i]) === null
					|| arg is (type = typeList[i]) )
					continue;
				
				throw new ArgumentError('Value object <' + arg
					+ '> is not an instance of <' + type + '>.');
			}
			
			for each (var f:Function in functionList)
			{
				f.apply(null, args)
			}
		}
	}
}