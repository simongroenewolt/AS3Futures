package org.osflash.futures.support
{
	import org.osflash.futures.IFuture;
	import org.osflash.futures.creation.instantSuccess;

	public function cascade(...items):IFuture
	{
		if (items.length == 0)
			return instantSuccess()
		
		var argsTotal:Array = []
		return next()
		
		function next(...args):IFuture
		{
			argsTotal = argsTotal.concat(args)
			
			if (argsTotal.length < items.length)
			{
				const current:IFuture = toFuture(items[argsTotal.length], argsTotal)
					
				if (current == null)
				{
					return instantSuccess.apply(null, argsTotal)
				}
				else
				{
					return current
						.andThen(next)
						.isolate()
				}
			}
			else
			{
				return instantSuccess.apply(null, argsTotal)
			}
		}
	}
}