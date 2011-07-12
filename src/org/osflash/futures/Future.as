package org.osflash.futures
{
	import flash.utils.Dictionary;
	
	import org.osflash.futures.support.assertFutureIsAlive;

	public class Future implements IFuture
	{
		protected var
			_onComplete:Function,
			_afterComplete:Function,
			_mapComplete:Object,
			
			_onCancel:Function,
			_afterCancel:Function,
			_mapCancel:Object,
			
			_onProgress:Function,
			_afterProgress:Function,
			_isPast:Boolean,
			
			isolator:IFuture
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void
		{
			_onComplete = _onCancel = _onProgress = null
		}	
			
		/**
		 * @inheritDoc
		 */
		public function get isPast():Boolean
		{
			return _isPast
		}
		
		/**
		 * @inheritDoc
		 */
		public function isolate():IFuture
		{
			assertAll(isolator, 'Isolate has already been called on this Future')
			isolator = new Future()
				
			afterComplete(isolator.complete)
			afterCancel(isolator.cancel)
				
			return isolator
		}
		
		/**
		 * @inheritDoc
		 */
		public function onProgress(f:Function):IFuture
		{
			assertAll(_onComplete, 'onProgress is already being handled')
			_onProgress = f;
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasProgressListener():Boolean
		{
			return _onProgress != null;
		}
		
		public function progress(unit:Number, ...args):void
		{
			assertThisFutureIsAlive()
			
			if (_onProgress != null)
			{
				args.unshift(unit)
				applyArgs(_onProgress, args)
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function onComplete(f:Function):IFuture
		{
			assertAll(_onComplete, 'onComplete is already being handled')
			_onComplete = f
			return this;
		}
		
		protected function afterComplete(f:Function):void
		{
			assertNotNull(_afterComplete, 'onComplete is already being handled')
			_afterComplete = f
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasCompleteListener():Boolean
		{
			return _onComplete != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function complete(...args):void
		{
			assertThisFutureIsAlive()
			
			applyArgsIfExists(_onComplete, args)
					
			_isPast = true
			
			applyArgsIfExists(_afterComplete, args)
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapComplete(funcOrObject:Object):IFuture
		{
			assertAll(_mapComplete, 'mapComplete is already being handled')
			_mapComplete = funcOrObject
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function onCancel(f:Function):IFuture
		{
			assertAll(_onCancel, 'onCancel is already being handled')
			_onCancel = f
			return this;
		}
		
		protected function afterCancel(f:Function):void
		{
			assertNotNull(_afterCancel, 'onComplete is already being handled')
			_afterCancel = f
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasCancelListener():Boolean
		{
			return _onCancel != null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function cancel(...args):void
		{
			assertThisFutureIsAlive()
			
			applyArgsIfExists(_onCancel, args)
				
			_isPast = true
				
			applyArgsIfExists(_afterCancel, args)
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapCancel(funcOrObject:Object):IFuture
		{
			assertNotNull(_onComplete, 'onCancel is already being handled')
			return null;
		}
		
		protected function assertAll(property:*, message:String):void
		{
			assertThisFutureIsAlive()
			assertNotNull(property, message)
		}
		
		protected function assertThisFutureIsAlive(message:String=null):void 
		{
			assertFutureIsAlive(this, message)
		}
		
		protected function assertNotNull(property:*, message:String):void 
		{
			if (property != null)
				throw new Error(message)
		}
		
		protected function map(mapper:Object, args:Array):Array
		{
			const mappedArgs:* = (mapper is Function) 
				? mapper.apply(null, args)
				: mapper
			
			if (mappedArgs is Array)
				return mappedArgs
			else
				return [mappedArgs]
		}
		
		protected function applyArgsIfExists(f:Function, mappedArgs:Object):*
		{
			if (f != null)
				applyArgs(f, mappedArgs)
		}
		
		protected function applyArgs(f:Function, mappedArgs:Object):*
		{
			if (mappedArgs is Array)
				return f.apply(null, mappedArgs)
			else
				return f(mappedArgs)
		}
	}
}