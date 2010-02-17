/**
 * FlashVarUtils by Tim Keir, Dec 12 2009 - http://www.timkeir.co.nz
 *
 * Copyright (c) 2009 Tim Keir
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
package prevail.utils
{
	public class FlashVarUtils
	{
		/** @private **/
		private static var fv:Object; 		// Reference to FlashVariables (root.loaderInfo.parameters)
		/** @private **/
		private static var val:String = "";	// Holds the value of a flash variable
		/** @private **/
		private static var key:String = "";	// Holds the name of a flash variable
		
		public function FlashVarUtils() { }
		
		/**
		 * 	Loops through all available Flash Variables, then checks
		 *	whether the passed in reference class has a matching public
		 * 	variable. If a match is found it sets it to the value of the
		 *	flash variable. Supports type casting to String, Boolean, Number, int, uint.
		 *
		 *	@param ref A reference to the class you wish to set variables for
		 */
		public static function checkVars(ref:Object):void
		{
			if(fv != null)
			{
				var c:String = ref.toString();
				trace("\n------------------------------------");
				trace("FlashVarUtils.as - setting vars in "+c.substr(8, c.length-9));
				trace("------------------------------------");
				val = ""; key = "";
				
				for(key in fv)
				{
					val = fv[key]; trace(key+" = '"+val+"'");
					try {
						if(val != null && val != "")
						{
							switch(typeof ref[key])
							{
								case "number":
									ref[key] = (val.indexOf(".") != -1) ? parseFloat(val) : parseInt(val); trace("\tcast as numeric: "+ref[key]);
									break;
								case "boolean":
									ref[key] = (val.toLowerCase() == "true") ? true : false; trace("\tcast as boolean");
									break;
								default:
									ref[key] = val; trace("\tcast as string");
									break;
							}
						}
						else trace("\tWARNING: '"+key+"' skipped because it's blank.");
					} catch(e:Error) {
						trace("\tERROR: '"+key+"' must be declared as a public variable.");
					}
				}
				trace("------------------------------------\n");
			} else { throw new Error("FlashVarUtils.as ERROR: First call the static method FlashVarUtils.flashVars = root.loaderInfo.parameters; from "+ref); }
		}
		
		/**
		 * Returns the Flash Variables object.
		 *
		 *	@return The flash variables object
		 */
		public static function get flashVars():Object
		{
			return fv;
		}
		/**
		 *	Sets the Flash Variables object.
		 *
		 *	@param _fv The flash variables object
		 */
		public static function set flashVars(_fv:Object):void
		{
			fv = _fv;
		}
	}
}