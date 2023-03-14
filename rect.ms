Rectangle = {}

Rectangle.make = function(x, y, width, height)
	r = new Rectangle
	r.x = x
	r.y = y
	r.width = width
	r.height = height
	return r
end function

Rectangle.left = function()
	return self.x
end function

Rectangle.right = function()
	return self.x + self.width - 1
end function

Rectangle.top = function()
	return self.y
end function

Rectangle.bottom = function()
	return self.y + self.height - 1
end function

Rectangle.contains = function(pnt)
	return self.left <= pnt.x and pnt.x <= self.right and self.top <= pnt.y and pnt.y <= self.bottom
end function
