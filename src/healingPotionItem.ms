HealingPotionItem = new item.Item
HealingPotionItem.tile = tile.make("!", Color.red, Color.black)
HealingPotionItem.dice = math.Dice.make(1, 1, 0)

HealingPotionItem.str = function()
	return self.name
end function

HealingPotionItem.effectStr = function()
	return "Inc HP:" + self.dice.str()
end function

HealingPotionItem.calculateHealingAmount = function()
	return self.dice.roll()
end function

HealingPotionItem.use = function(entity)
	healingAmount = self.calculateHealingAmount()
	healingAmount = entity.modifyHP(healingAmount)	
end function
