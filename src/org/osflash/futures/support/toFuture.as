package org.osflash.futures.support
{
	import org.osflash.futures.IFuture;

	/**
	 *  
	 */	
	public function toFuture(source:*, args:Array=null):IFuture
	{
		if (source is IFuture)			
		{
			return source
		}
		else if (source is Function)	
		{
			args = args || []
			return source.apply(null, args)
		}
		else 
		{
			throw new Error('source should be either a IFuture or a Function that returns an IFuture')
		}
	}
}