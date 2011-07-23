package org.osflash.futures.support
{
	public function applyArgs(f:Function, args:Object):*
	{
		if (args is Array)
			return f.apply(null, args)
		else
			return f(args)
	}
}