AS3 Futures is an effort to make a small set of classes to help handle asynchronous calls in AS3. Native Flash Events can of course be used for this, but they have their problems, many of which are discussed by Robert Penner:

* [My Critique of AS3 Events - Part 1](http://robertpenner.com/flashblog/2009/08/my-critique-of-as3-events-part-1.html)
* [AS3 Events - 7 things I've learned from community](http://robertpenner.com/flashblog/2009/09/as3-events-7-things-ive-learned-from.html)
* [My Critique of AS3 Events - Part 2](http://robertpenner.com/flashblog/2009/09/my-critique-of-as3-events-part-2.html)

These criticism's motivated Robert to make the [AS3Signals](https://github.com/robertpenner/as3-signals/) lib, itself based on signal/slots from the Qt framework. I find Signals to be a big improvement over native Events but let me explain why I made a little interface called Future...

Lets make a ServerClient:

	public class ServerClient
	{
		public const
			userLogInSucceeded:Signal = new Signal(XML), // server returns XML
			userLogInFailed:Signal = new Signal(String), // server returns a reason the log in failed
			userLogOutSucceeded:Signal = new Signal(),
			userLogOutFailed:Signal = new Signal(String) // server returns a reason the log out failed
		
		public function logIn(name:String, pass:String):void
		{
			// send log in request to server
			// dispatch userLogInSucceeded when it returns
			// dispatch userLogInFailed if something goes wrong
		}
	
		public function logOut():void
		{
			// send log out request to server
			// dispatch userLogOutSucceeded when it returns
			// dispatch userLogOutFailed if something goes wrong
		}
	}

Nothing crazy here, some calling code might look like this:

	public function doSomeServerShizzle(server:ServerClient):void
	{		
		server.userLogInSucceeded.addOnce(function (playerData:XML):void {
			trace('nice, we're in!')
		})
		server.userLogInFailed.addonce(function (reason:String):void {
			trace('Poo, log in failed:', reason)
		})
		
		server.logIn('brian', 'wentelteefjes')
	}

Ok great, but look at the usage of this ServerClient and more specifically the signals. If I charted out the usage of the userLogInSucceeded Signal over time, we would see that the ServerClient object lives, let's say for the life time of the application. But the userLogInSucceeded Signal is only dispatching data when the logIn method is called, and other than that it's silent. This means I have a Signal object mostly idle. 

Also looking at the Signal does not tell me under what conditions the userLogInSucceeded Signal will dispatch. And even more, I could write a line of code what listens to a signal at the top of a class, and call the logIn method at the bottom, leaving a gulf of source code between two highly related pieces of code. I asked myself why do I need Signals at the top of the class at all? Why not return a Signal from the logIn method?

But then the logIn method can both succeed or fail, so I would have to pass back two signals. Hmmmmm...

What I propose is that the ServerClient is modified so that the logIn and logOut methods return a Future. 

	public interface Future
	{		
		function onCompleted(f:Function):Future
		function complete(...args):void
			
		function onCancelled(f:Function):Future		
		function cancel(...args):void
			
		... and some other bits and pieces
	}

By returning a Future from a method I am saying that this method performs an asynchronous operation. And yes we have just lost static typing, but lets not get into a heated hand waving, foot stomping debate about it.

	public class ServerClient
	{
		public function logIn():Future
		{
			// the complete type is XML and the cancel type is String
			const future:Future = new TypedFuture([XML], [String])
		
			// send log in request to server
			// call future.complete when it returns
			// call future.cancel if something goes wrong
		
			return future
		}
	
		public function logOut():Future
		{
			const future:Future = new TypedFuture([], [String])
			
			// send log out request to server
			// call future.complete when it returns
			// call future.cancel if something goes wrong
			
			return future
		}
	}
	
The calling code now becomes:

	public function doSomeServerShizzle(server:ServerClient):void
	{	
		server.logIn('brian', 'wentelteefjes')
			.onComplete(function (playerData:XML):void {
				trace('nice, we're in!')
			})
			.onCancel(function (reason:String):void {
				trace('Poo, log in failed:', reason)
			})
	}
	
The difference here is that I am giving back a unique object representing my logIn request. That object is a Future and has a short well defined lifetime. When logIn is requested there are two possibilities: 

* the request is satisfied/completed
* the request is not satisfied/cancelled

Either way the Futures raison d'etre is no more, and it is disposed of. Disposal means that any listening functions are detached from the Future.

What are the things I like about this approach?

* The method signature tells me that it is an asynchronous operation
* I don't have to clean up the Future, it knows when it's life is over
* The handling of the all outcomes of a request is easy to place right beside the request
* I don't have to guess/search for what Events/Signals are fired in response to this request 

Lets look at a practical runnable code example. A simple function that loads multiple types of resources. 
I want the signature to be something like:

	function load(url:String, map:Function=null):FutureProgressable

I can supply a url and a mapping function (you'll see what this is for shortly) and of course we return a Future because a load operation is asynchronous. We are returning a more specific type of Future, a FutureProgressable (yep that's a bit long indeed, but it's descriptive) which adds the ability to be notified of the progress of the async operation.

	public interface FutureProgressable extends Future
	{
		function onProgress(callback:Function):FutureProgressable
		function progress(unit:Number):void
	}
	
The progress is given as a unit range Number [0->1] therefore the signiture of the callback function needs to be:

	function progressCallback(progressUnit:Number):void {}
	
Without further ado, here is the load function in it entirety, check out the completeHandler, progressHandler and errorHandler closures:

	package org.osflash.loady.io
	{
		import flash.display.Loader;
		import flash.events.*;
		import flash.net.*;
	
		import org.osflash.futures.FutureProgressable;
		import org.osflash.futures.TypedFuture;

		public function load(url:String, map:Function=null):FutureProgressable
		{
			const future:FutureProgressable = new TypedFuture()
			
			// guess if the data is binary based on it's file extension
			const isBinary:Boolean = url.search('\.swf$|\.png$|\.jpg$|\.jpeg$|\.mp3') >= 0
		
			var loader:Object
			var eventReporter:IEventDispatcher
		
			// binary files needs a different loader
			if (isBinary)
			{
				// TODO: add support for loading audio
				loader = new Loader()
				eventReporter = loader.contentLoaderInfo
			}
			else
			{
				loader = new URLLoader()
				eventReporter = IEventDispatcher(loader)
			}
		
			const completeHandler:Function = function (e:Event):void {
				removeEvents()
			
				const data:* = (isBinary)
					? loader.contentLoaderInfo.content
					: loader.data
			
				// complete the loading future and map the loaded data to a new type if needed
				future.complete((map == null) ? data : map(data))	
			}
		
			const progressHandler:Function = function (e:ProgressEvent):void {
				// update any listeners of the progress
				future.progress(e.bytesTotal / e.bytesLoaded)
			}
		
			const errorHandler:Function = function (e:ErrorEvent):void {
				// something nasty happened cancel the future
				removeEvents()
				future.cancel(e)
			}
		
			const removeEvents:Function = function():void {
				eventReporter.removeEventListener(Event.COMPLETE, completeHandler)
				eventReporter.removeEventListener(ProgressEvent.PROGRESS, progressHandler)
				eventReporter.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler)
				eventReporter.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler)
			}
		
			eventReporter.addEventListener(Event.COMPLETE, completeHandler)
			eventReporter.addEventListener(ProgressEvent.PROGRESS, progressHandler)
			eventReporter.addEventListener(IOErrorEvent.IO_ERROR, errorHandler)
			eventReporter.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler)
		
			loader.load(new URLRequest(url))
		
			return future
		}
	}

There you go, a pretty useful loading function without Events or Signals. So what does the calling code look like?:

	public function applicationSetup():void
	{
		load('config.xml')
			.onComplete(function (rawXML:String):void {
				const config:XML = new XML(rawXML)
				
				// do stuff with the config info ...
			})
			.onCancel(function (e:ErrorEvent):void {
				// log the error or do something more constructive
			})
	}
	
The keen of eye will notice that the Future returned from the load function is not actually saved anywhere. Therefore it is eligible for garbage collection. This is what I use the FutureSentinalSingle and FutureSentinalList classes for, to hold onto the references of the Futures and throw away the reference when the Future is past.

	public const sentinal:FutureSentinalList

	public function applicationSetup():void
	{
		sentinal.watch(
			load('config.xml')
				.onComplete(function (rawXML:String):void {
					const config:XML = new XML(rawXML)
			
					// do stuff with the config info ...
				})
				.onCancel(function (e:ErrorEvent):void {
					// log the error or do something more constructive
				})
		)
	}
	
A Future can also be synced with more Futures. This is done by calling the waitOnCritical method. But more on this later...

Watch this space for more async goodness...