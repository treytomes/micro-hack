Color = new Object()
Color._r = 0
Color._g = 0
Color._b = 0
Color._a = 0

Color.init = function(r, g, b, a = 255)
	super.init()

	self._r = r
	self._g = g
	self._b = b
	self._a = a
	if self._a > 255 then self._a = 255
	if self._a < 0 then self._a = 0

	self._html = color.fromList([ self._r, self._g, self._b, self._a ])
	
	return self
end function

Color.fromList = function(lst)
	return (new Color).init(lst[0], lst[1], lst[2], lst[3])
end function

Color.fromHtml = function(html)
	return self.fromList(color.toList(html))
end function

Color.random = function()
	return (new Color).init(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end function

Color.red = (new Color).init(255, 0, 0)
Color.flame = (new Color).init(255, 63, 0)
Color.orange = (new Color).init(255, 127, 0)
Color.amber = (new Color).init(255, 191, 0)
Color.yellow = (new Color).init(255, 255, 0)
Color.lime = (new Color).init(191, 255, 0)
Color.chartreuse = (new Color).init(127, 255, 0)
Color.green = (new Color).init(0, 255, 0)
Color.sea = (new Color).init(0, 255, 127)
Color.turquoise = (new Color).init(0, 255, 191)
Color.cyan = (new Color).init(0, 255, 255)
Color.sky = (new Color).init(0, 191, 255)
Color.azure = (new Color).init(0, 127, 255)
Color.blue = (new Color).init(0, 0, 255)
Color.han = (new Color).init(63, 0, 255)
Color.violet = (new Color).init(127, 0, 255)
Color.purple = (new Color).init(191, 0, 255)
Color.fuchsia = (new Color).init(255, 0, 255)
Color.magenta = (new Color).init(255, 0, 191)
Color.pink = (new Color).init(255, 0, 127)
Color.crimson = (new Color).init(255, 0, 63)

Color.brass = (new Color).init(191, 151, 96)
Color.copper = (new Color).init(191, 136, 124)
Color.gold = (new Color).init(229, 191, 0)
Color.silver = (new Color).init(203, 203, 203)

Color.grey = (new Color).init(127, 127, 127)
Color.gray = Color.grey
Color.sepia = (new Color).init(158, 134, 100)

Color.transparent = (new Color).init(0, 0, 0, 0)

// Copy in some of the missing built-in color palette.
Color.clear = Color.transparent
Color.black = (new Color).init(0, 0, 0)
Color.white = (new Color).init(255, 255, 255)
Color.maroon = Color.fromHtml(color.maroon)
Color.olive = Color.fromHtml(color.olive)
Color.teal = Color.fromHtml(color.teal)
Color.aqua = Color.fromHtml(color.aqua)
Color.fuchsia = Color.fromHtml(color.fuchsia)
Color.brown = Color.fromHtml(color.brown)

Color.str = function()
	return self._html
end function

Color.lerp = function(start, finish, n)
	//return color.lerp(start._html, finish._html, n)
	r = math.lerp(start._r, finish._r, n)
	g = math.lerp(start._g, finish._g, n)
	b = math.lerp(start._b, finish._b, n)
	a = math.lerp(start._a, finish._a, n)
	return (new Color).init(r, g, b, a)
end function

Color.add = function(clr)
	return (new Color).init(self._r + clr._r, self._g + clr._g, self._b + clr._b, self._a + clr._a)
end function

Color.subtract = function(clr)
	return (new Color).init(self._r - clr._r, self._g - clr._g, self._b - clr._b, self._a - clr._a)
end function

Color.scale = function(v)
	return (new Color).init(v * self._r, v * self._g, v * self._b, self._a)
end function

Color.inverted = function()
	return (new Color).init(255 - self._r, 255 - self._g, 255 - self._b, 255)
end function

Color.desaturated = function()
	return self.white.subtract(self).scale(0.5).add(self).scale(0.5)
end function

Color.lightest = function()
	return self.white.subtract(self).scale(0.75).add(self)
end function

Color.lighter = function()
	return self.white.subtract(self).scale(0.65).add(self)
end function

Color.light = function()
	return self.white.subtract(self).scale(0.45).add(self)
end function

Color.dark = function()
	return self.scale(0.75)
end function

Color.darker = function()
	return self.scale(0.5)
end function

Color.darkest = function()
	return self.scale(0.25)
end function

globals.Color = Color

// Convert a Color.object to a Color.string.
color.fromColor = function(clr)
	return clr.str()
end function

// We're only modifying the global scope, not adding a colorUtil namespace.
return null
