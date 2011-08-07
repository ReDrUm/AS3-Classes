/**
 * URLUtils by Tim Keir, Aug 7 2011 - http://www.timkeir.co.nz
 *
 * Copyright (c) 2011 Tim Keir
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package com.timkeir.utils
{
	import flash.events.IOErrorEvent;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	/**
	 *	URL Utilities.
	 *
	 *	<p>Although this class is technically an Event it is intended to be used as a static 
	 *	utility class to simplify opening urls and sending/receiving data from a server.</p>
	 *	
	 *	@example
	 *	<listing version="3.0">
	 *	// To launch a new window
	 *	URLUtils.open("http://www.google.com", "_blank");
	 *	
	 *	// To POST data to a server
	 *	URLUtils.addEventListener(URLUtils.DATA_POST_SUCCESS, postHandler);
	 *	URLUtils.addEventListener(URLUtils.DATA_POST_FAILED, postHandler);
	 *	URLUtils.submit("http://www.example.com?testVar=hello%20world");
	 *	
	 *	// Receive response data from POST
	 *	function postHandler(event:URLUtils):void {
	 *		if(event.type == URLUtils.DATA_POST_SUCCESS) response = event.data;
	 *	}
	 *	</listing>
	 *
	 *	@author Tim Keir
	 *	@created 28/05/2008
	 *	@modified 28/07/2011
	 */
	public class URLUtils extends Event
	{
		// Event Variables
		public static const DATA_POST_SUCCESS:String = "dataReady";
		public static const DATA_POST_FAILED:String = "dataError";
		private var _data:String;
		
		// Util Variables
		protected static var disp:EventDispatcher;
		
		/**
		 * This class should only be instantiated from within itself via postHandler().
		 * Instead you can use its static functions open() and submit().
		 * 
		 * I've chosen not to enforce a Singleton pattern in case anyone does feel the 
		 * need to manually create and dispatch this as an event.
		 */
		public function URLUtils(type:String, responseData:String = "", bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_data = responseData;
			
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Clones the event including its data.
		 * 
		 * <p>This is useful when redispatching the event within an event listener.</p>
		 * 
		 * @return A clone of the event
		 */
		public override function clone():Event
		{
			return new URLUtils(type, _data, bubbles, cancelable);
		}
		
		/**
		 * Returns the servers data response.
		 * 
		 * @return The response from the server
		 */
		public function get data():String
		{
			return _data;
		}
		/**
		 * @see data()
		 */
		public function get response():String
		{
			return _data;
		}
		
		/**
		 * Launch a URL in a new window
		 *
		 * @param url The URL to open
		 * @param target The target window e.g. _blank or _self
		 */
		public static function open(url:String, target:String = "_self"):void
		{
			var targetURL:URLRequest = new URLRequest(url);
			try { navigateToURL(targetURL, target); }
			catch (e:Error) { trace("URLUtils.as: ERROR launching website: "+url); }
		}
		
		/**
		 * Send data to a url using either a query string (as if you were using GET) or URLVariables.
		 *
		 * @param url The URL you will send data to with support for GET style query strings. e.g. http://www.example.com/receive.php?var1=Hello&var2=World
		 * @param data The variables to send to the url. This is an alternate method of defining data to compliment the GET style approach above.
		 * @param method Whether to use URLRequestMethod.POST or URLRequestMethod.GET. Defaults to POST unless the url contains a query string and data is null.
		 */
		public static function submit(url:String, data:URLVariables = null, method:String = ""):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, postHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, postHandler);
			
			// Store original url for reference in error handling.
			var _url:String = url;
			
			// Check for query string
			if(url.indexOf("?") != -1)
			{
				// Default to GET if data and method are not specified
				if(!data && !method) method = "GET";
				
				// Create new instance if empty
				data ||= new URLVariables();
				
				// Isolate query string
				var i:uint = url.indexOf("?");
				var query:String = url.substring(i+1);
				var parameters:Array = query.split("&");
				var numParams:int = parameters.length;
				// Isolate page
				url = url.substr(0, i);
				
				// Loop through parameters as key and value pairs
				var j:int; var key:String; var val:String;
				
				for(i = 0; i < numParams; i++)
				{
					// Define tracking variables to be sent to targetURL
					j = String(parameters[i]).indexOf("=");
					key = String(parameters[i]).substr(0, j);
					val = String(parameters[i]).substring(j+1);
					data[key] = val;
				}
			}
			
			// Use POST if method isn't specified
			method ||= "POST";
			
			// Setup for posting data variables
			var targetURL:URLRequest = new URLRequest(url);
			targetURL.method = method;
			targetURL.data = data;
			
			// Post data to page
			try { loader.load(targetURL); }
			catch (e:Error) { trace("URLUtils.as: ERROR posting data: "+_url+"\n"+e.message); }
		}
		
		/**
		 * Response handler for sending data via submit().
		 * 
		 * <p>Creates a new instance of this class and dispatches the response.
		 * If the post was successful you can then access the response data using
		 * the data() or response() getters.</p>
		 * 
		 * @see post()
		 * @see data() or response();
		 * 
		 * @param e Receives either Event.COMPLETE or IOErrorEvent.IO_ERROR
		 */
		protected static function postHandler(event:Event):void
		{
			if(event.type == "complete")
			{
				// Attach the server response
				var loader:URLLoader = URLLoader(event.target);
				dispatchEvent(new URLUtils(URLUtils.DATA_POST_SUCCESS, loader.data));
			}
			else dispatchEvent(new URLUtils(URLUtils.DATA_POST_FAILED));
		}
		
		/**
		 * @private
		 * The below functions are used to enable static dispatching of events.
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if(disp == null) disp = new EventDispatcher();
			disp.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		/** @private */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if(disp == null) return;
			disp.removeEventListener(type, listener, useCapture);
		}
		/** @private */
		public static function dispatchEvent(event:Event):void
		{
			if(disp == null) return;
			disp.dispatchEvent(event);
		}
	}
}
