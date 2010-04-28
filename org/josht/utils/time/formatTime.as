﻿/*Copyright (c) 2010 Josh TynjalaPermission is hereby granted, free of charge, to any personobtaining a copy of this software and associated documentationfiles (the "Software"), to deal in the Software withoutrestriction, including without limitation the rights to use,copy, modify, merge, publish, distribute, sublicense, and/or sellcopies of the Software, and to permit persons to whom theSoftware is furnished to do so, subject to the followingconditions:The above copyright notice and this permission notice shall beincluded in all copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIESOF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE ANDNONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHTHOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISINGFROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OROTHER DEALINGS IN THE SOFTWARE.*/package org.josht.utils.time{	import org.josht.utils.string.padFrontOfString;	public function formatTime(milliseconds:int, includeMilliseconds:Boolean = false):String	{		var seconds:int = milliseconds / 1000;		if(includeMilliseconds)		{			milliseconds -= (seconds * 1000)		}		var minutes:int = seconds / 60;		seconds -= (minutes * 60);		var hours:int = minutes / 60;		minutes -= (hours * 60);				var formattedTime:String = "";		if(hours > 0)		{			formattedTime += hours.toString() + ":";		}		if(minutes > 0 || !includeMilliseconds)		{			formattedTime += padFrontOfString(minutes.toString(), 2, "0") + ":";		}		formattedTime += padFrontOfString(seconds.toString(), 2, "0");		if(includeMilliseconds)		{			formattedTime += "." + padFrontOfString(milliseconds.toString(), 3, "0");		}				return formattedTime;	}}