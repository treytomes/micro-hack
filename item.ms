Item = {}
Item.name = "n/a"
Item.isConsumedOnUse = true
Item.tile = tile.make("?", color.gray, color.black)

Item.init = function(name)
	self.name = name
end function

Item.str = function()
	return self.name
end function

Item.use = function(entity)
end function
