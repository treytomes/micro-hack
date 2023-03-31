Point = {}

Point.init = function(x, y)
	self.x = x
	self.y = y
	return self
end function

Point.str = function()
	return "({0}, {1})".fill([ self.x, self.y ])
end function

Point.multiply = function(n)
	return (new Point).init(n * self.x, n * self.y)
end function

Point.negate = function()
	return (new Point).init(-self.x, -self.y)
end function

Point.add = function(pnt)
	return (new Point).init(self.x + pnt.x, self.y + pnt.y)
end function

Point.subtract = function(pnt)
	return (new Point).init(self.x - pnt.x, self.y - pnt.y)
end function

Point.sign = function(pnt)
	return (new Point).init(sign(self.x), sign(self.y))
end function

Point.scale = function(v)
	return (new Point).init(v * self.x, v * self.y)
end function

zero = function()
	return (new Point).init(0, 0)
end function

unitX = function()
	return (new Point).init(1, 0)
end function

unitY = function()
	return (new Point).init(0, 1)
end function

make = function(x, y)
	return (new Point).init(x, y)
end function
