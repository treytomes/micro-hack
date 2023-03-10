Point = {}
Point.make = function(x, y)
	p = new Point
	p.x = x
	p.y = y
	return p
end function

Point.add = function(pnt)
	self.x += pnt.x
	self.y += pnt.y
end function
