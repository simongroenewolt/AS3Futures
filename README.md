AS3 Futures is an effort to make a small set of classes to help handle asynchronous communication in AS3. Native Flash Events can of course be used for this, but they have their problems, many of which are discussed by Robert Penner:

* [My Critique of AS3 Events - Part 1](http://robertpenner.com/flashblog/2009/08/my-critique-of-as3-events-part-1.html)
* [AS3 Events - 7 things I've learned from community](http://robertpenner.com/flashblog/2009/09/as3-events-7-things-ive-learned-from.html)
* [My Critique of AS3 Events - Part 2](http://robertpenner.com/flashblog/2009/09/my-critique-of-as3-events-part-2.html)

These criticism's motivated Robert to make the [AS3Signals](https://github.com/robertpenner/as3-signals/) lib itself based on signal/slots from the Qt framework. I find Signals to be a big improvement over native Events but let me explain why I made an interface called Future:

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

Nothing crazy here, come calling code might look like this:

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

Ok great, but look at the usage of this ServerClient and more specifically the signals. If I drew out the usage of the userLogInSucceeded Signal over time, we would see that the ServerClient object lives, let's say for the life time of the application. But the userLogInSucceeded is only dispatching data when the logIn method is called, and other than that it's silent. Also I'm not really sure under what conditions the userLogInSucceeded Signal will dispatch. And even more, I write a line of code what listens to a signal at the top of a class, and only call the logIn method at the bottom, leaving a gulf of source code between two highly related pieces of code. 

What I propose is that the ServerClient is modified so that the logIn and logOut methods return a Future. 

	public interface Future
	{		
		function onCompleted(f:Function):Future
		function complete(...args):void
			
		function onCancelled(f:Function):Future		
		function cancel(...args):void
			
		... and some other bits and pieces
	}

By returning a Future from a method I am saying that this method perform an asynchronous operation. And yes we have just lost static typing, but lets not get into a heated hand waving, foot stomping debate about it.

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
			.onCompete(function (playerData:XML):void {
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