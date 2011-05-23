package org.osflash.futures
{
	public class ListenerList
	{
		protected const functionList:Array = []
		protected var typeList:Array = []
		
		public function ListenerList(types:Array=null)
		{
			if (types) 
				this.typeList = types
		}
		
		protected function assertListenerArgumentLength(listener:Function, length:uint):void
		{
			if (listener.length < length)
			{
				const argumentString:String = (listener.length == 1) ? 'argument' : 'arguments';
				
				throw new ArgumentError('Listener has '+listener.length+' '+argumentString+' but it needs at least '+
					length+' to match the given types.');
			}
		}
		
		public function add(f:Function):void
		{
			assertListenerArgumentLength(f, typeList.length)
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
		
		public function dispose():void
		{
			functionList.length = 0
		}
	}
}