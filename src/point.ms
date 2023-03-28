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

Point.subtract = function(pnt)
	return self.make(self.x - pnt.x, self.y - pnt.y)
end function

Point.sign = function(pnt)
	return self.make(sign(self.x), sign(self.y))
end function

Point.scale = function(v)
	return self.make(v * self.x, v * self.y)
end function

zero = function()
	return Point.make(0, 0)
end function

unitX = function()
	return Point.make(1, 0)
end function

unitY = function()
	return Point.make(0, 1)
end function

make = function(x, y)
	return Point.make(x, y)
end function