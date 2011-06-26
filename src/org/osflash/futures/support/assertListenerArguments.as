package org.osflash.futures.support
{
	public function assertListenerArguments(listener:Function, types:Array):void
	{
		const typeAmount:uint = types.length
			
		if (listener.length != 0 && listener.length < typeAmount)
		{
			const argumentString:String = (listener.length == 1) ? 'argument' : 'arguments';
			
			throw new ArgumentError('Listener has '+listener.length+' '+argumentString+' but it needs at least '+
				typeAmount+' to match the given types.');
		}
	}
}