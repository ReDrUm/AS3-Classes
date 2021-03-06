/**
 * TimelineUtils by Tim Keir, Nov 16 2010 - http://www.timkeir.co.nz
 *
 * Copyright (c) 2010 Tim Keir
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
	import flash.display.MovieClip;

	public class TimelineUtils
	{
		public function TimelineUtils() { }
		
		/**
		 * 	Temporarily pauses a MovieClips timeline for a defined interval.
		 *	The timeline then automatically resumes after the interval has passed.
		 *
		 *	@param tl 		A reference to the MovieClip timeline you wish to pause.
		 *	@param delay	The duration of the delay you wish to pause for in milliseconds.
		 */
		public static function delay(timeline:MovieClip, duration:Number = 3000):void
		{
			var pauser:Pauser = new Pauser(timeline, duration);
		}
	}
}

import flash.display.MovieClip;
import flash.utils.Timer;
import flash.events.TimerEvent;

class Pauser
{
	/** @private **/
	private var timeline:MovieClip;
	
	/**
	 * 	Pauses the defined MovieClips timeline
	 *
	 *	@param	tl		A reference to the MovieClip timeline you wish to pause.
	 *	@param	delay	The duration of the delay in milliseconds.
	 */
	public function Pauser(tl:MovieClip, delay:Number):void
	{
		timeline = tl;
		timeline.stop();
		
		var pauser:Timer = new Timer(delay, 1);
		pauser.addEventListener(TimerEvent.TIMER, resumeTimeline);
		pauser.start();
	}
	
	/**
	 * 	Resumes the defined MovieClips timeline.
	 *	Triggered from the Timer created within Pauser()
	 */
	private function resumeTimeline(e:TimerEvent):void
	{
		e.target.reset();
		e.target.removeEventListener(e.type, arguments.callee);
		var pauser:Timer = e.target as Timer;
		pauser = null;
		timeline.play();
		timeline = null;
		this = null;
	}
}