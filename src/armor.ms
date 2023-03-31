Armor = new item.Item
Armor.isConsumedOnUse = false
Armor.armorClass = 0
Armor.tile = tile.make("[", Color.gray.dark, Color.black)

Armor.str = function()
	return self.name
end function

Armor.effectStr = function()
	return "AC: " + self.armorClass
end function

Armor.use = function(entity)
	if self.equals(entity.armor) then
		entity.armor = null
	else
		entity.armor = self
	end if
end function
