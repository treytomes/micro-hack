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

Rectangle.centerX = function()
	return floor(self.x + self.width / 2)
end function

Rectangle.centerY = function()
	return floor(self.y + self.height / 2)
end function

// `thing` can be a Rectangle, Point, or list of Rectangles or Points recursively.
Rectangle.contains = function(thing)
	if thing isa point.Point then
		return self.left <= pnt.x and pnt.x <= self.right and self.top <= pnt.y and pnt.y <= self.bottom
	else if thing isa Rectangle then
		return self.contains(point.make(thing.left, thing.top)) and self.contains(point.make(thing.left, thing.bottom)) and self.contains(point.make(thing.right, thing.top)) and self.contains(point.make(thing.right, thing.bottom))
	else if thing isa list then
		for pnt in thing
			if not self.contains(pnt) then return false
		end for
		return true
	else
		return false
	end if
end function

// `thing` can be a Rectangle, Point, or list of Rectangles or Points recursively.
Rectangle.intersects = function(thing)
	if thing isa point.Point then
		return self.contains(thing)
	else if thing isa Rectangle then
		return self.left <= thing.right and thing.left <= self.right and self.top <= thing.bottom and thing.top <= self.bottom
	else if thing isa list then
		for pnt in thing
			if pnt.contains(thing) then return true
		end for
		return false
	end if
end function

make = function(x, y, width, height)
	return Rectangle.make(x, y, width, height)
end function
