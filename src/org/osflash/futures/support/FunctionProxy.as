package org.osflash.futures.support
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	public dynamic class FunctionProxy extends Proxy 
	{
		override flash_proxy function callProperty(propName:*, ...callArgs):* 
		{
			const f:Function = callArgs[0]
			
			return function(...callbackArgs):* {
				try
				{
					return applyArgs(f, callbackArgs)
				}
				catch (e:Error)
				{
					throw new Error('Error in scope: '+propName+' error:'+e.toString())
				}
			};
		}
	}
}