package org.josht.utils.point
{
	public function distanceXY(x1:Number, y1:Number, x2:Number, y2:Number):Number
	{
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
	}
}