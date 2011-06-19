package org.osflash.futures.support
{

	public class ListenerList
	{
		protected var functionList:Array = []
		protected var typeList:Array = []
		
		public function ListenerList(types:Array=null)
		{
			if (types) 
				this.typeList = types
		}
		
		protected function hasEqualTypes(other:ListenerList):Boolean
		{
			const typeAmount:uint = typeList.length;
			
			var otherType:*
			var type:*
			
			for (var i:int = 0; i < typeAmount; i++)
			{
				otherType = other.typeList[i]
				type = typeList[i]
				
				if (type !== otherType)
					return false
			}
			
			return true
		}
		
		protected function compareTypes(other:ListenerList):Array
		{
			const conflicts:Array = []
			const typeAmount:uint = typeList.length;
			
			var otherType:*
			var type:*
			
			for (var i:int = 0; i < typeAmount; i++)
			{
				otherType = other.typeList[i]
				type = typeList[i]
					
				if (type !== otherType)
					conflicts.push({index:i, type:type, otherType:otherType})
			}
			
			return conflicts
		}
		
		public function add(f:Function):void
		{
			assertListenerArguments(f, typeList.length)
			functionList.push(f)
		}
		
		public function dispatch(args:Array):void
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
		
		public function appendOther(other:ListenerList):void
		{
			functionList = functionList.concat(other.functionList)
			
		}	
		
		public function dispose():void
		{
			functionList.length = 0
		}
	}
}