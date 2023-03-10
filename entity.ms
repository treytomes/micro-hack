import "point"

Entity = {}
Entity.make = function(x, y)
	e = new Entity
	e.position = point.Point.make(x, y)
	e.backgroundColor = color.black
	e.foregroundColor = color.white
	e.tile = "@"
	return e
end function

Entity.draw = function()
	text.setCellColor self.position.x, self.position.y, self.foregroundColor
	text.setCellBackColor self.position.x, self.position.y, self.backgroundColor
	text.setCell self.position.x, self.position.y, self.tile
end function

Entity.erase = function()
	text.setCell self.position.x, self.position.y, " "
	text.setCellColor self.position.x, self.position.y, color.clear
	text.setCellBackColor self.position.x, self.position.y, color.black
end function
