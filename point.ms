Point = {}
Point.make = function(x, y)
	p = new Point
	p.x = x
	p.y = y
	return p
end function

Point.multiply = function(n)
	return self.make(n * self.x, n * self.y)
end function

Point.negate = function()
	return self.make(-self.x, -self.y)
end function

Point.add = function(pnt)
	return self.make(self.x + pnt.x, self.y + pnt.y)
end function

Point.zero = function()
	return Point.make(0, 0)
end function

Point.unitX = function()
	return Point.make(1, 0)
end function

Point.unitY = function()
	return Point.make(0, 1)
end function
