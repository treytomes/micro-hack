Item = {}
Item.name = "n/a"
Item.isConsumedOnUse = true

Item.str = function()
	return self.name
end function

Item.use = function(entity)
end function

HealingPotionItem = new Item
HealingPotionItem.dice = math.Dice.make(1, 1, 0)

HealingPotionItem.str = function()
	return self.name + " (" + self.dice.str() + ")"
end function

HealingPotionItem.calculateHealingAmount = function()
	return self.dice.roll()
end function

HealingPotionItem.use = function(entity)
	healingAmount = self.calculateHealingAmount()
	healingAmount = entity.modifyHP(healingAmount)
	Service.messages.report(entity.name + " was healed by " + healingAmount + " HP.")
	Service.makeMessageParticles(entity.position.x, entity.position.y, healingAmount, color.green)	
end function

basicHealingPotion = new HealingPotionItem
basicHealingPotion.name = "basic healing potion"
basicHealingPotion.dice = math.Dice.make(2, 4, 2)

greaterHealingPotion = new HealingPotionItem
greaterHealingPotion.name = "greater healing potion"
greaterHealingPotion.dice = math.Dice.make(4, 4, 4)

superiorHealingPotion = new HealingPotionItem
superiorHealingPotion.name = "superior healing potion"
superiorHealingPotion.dice = math.Dice.make(8, 4, 8)
