package org.osflash.futures.support
{
	public function applyArgsIfExists(f:Function, args:Object):*
	{
		if (f != null)
			applyArgs(f, args)
	}
}