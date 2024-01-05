Item = new Object
Item.name = "n/a"
Item.isConsumedOnUse = true
Item.tile = tile.make("?", Color.gray, Color.black)
Item.weight = 0
Item.goldValue = 0
Item.description = "N/A"

// These 2 attributes represent the level you might find this item on, along with how often it spawns there.
Item.level = 0
Item.rarity = 0

Item.init = function(name, level, rarity)
	super.init()
	self.name = name
	self.level = level
	self.rarity = rarity
	itemDb.addItem(self)
end function

Item.str = function()
	return self.name
end function

Item.effectStr = function()
	return ""
end function

Item.use = function(entity)
end function
