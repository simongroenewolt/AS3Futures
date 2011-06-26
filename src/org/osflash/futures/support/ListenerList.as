package org.osflash.futures.support
{

	public class ListenerList
	{
		public var 
			functionList:Array = []
			typeList:Array = []
		
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
		
		public function dispose():void
		{
			functionList.length = 0
		}
	}
}