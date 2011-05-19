package org.osflash.futures
{
	public class CallbackList
	{
		protected const functions:Array = []
		protected var types:Array = []
		
		public function CallbackList(types:Array=null)
		{
			if (types) 
				this.types = types
		}
		
		public function add(f:Function):void
		{
			functions.push(f)
		}
		
		public function dispatch(args:Array):void
		{
			for each (var f:Function in functions)
			{
				f.apply(null, args)
			}
		}
		
		public function dispose():void
		{
			functions.length = 0
		}
	}
}