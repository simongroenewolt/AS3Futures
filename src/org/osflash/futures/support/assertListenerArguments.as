package org.osflash.futures
{
	public function assertListenerArguments(listener:Function, length:uint):void
	{
		if (listener.length != 0 && listener.length < length)
		{
			const argumentString:String = (listener.length == 1) ? 'argument' : 'arguments';
			
			throw new ArgumentError('Listener has '+listener.length+' '+argumentString+' but it needs at least '+
				length+' to match the given types.');
		}
	}
}