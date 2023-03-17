Item = {}
Item.name = "n/a"
Item.isConsumedOnUse = true

Item.use = function(entity)
end function

HealingPotionItem = new Item
HealingPotionItem.numDice = 1
HealingPotionItem.numSides = 1
HealingPotionItem.modifier = 0

HealingPotionItem.calculateHealingAmount = function()
	return math.rollDice(self.numDice, self.numSides, self.modifier)
end function

HealingPotionItem.use = function(entity)
	healingAmount = self.calculateHealingAmount()
	healingAmount = entity.modifyHP(healingAmount)
	Service.messages.report(entity.name + " was healed by " + healingAmount + " HP.")
	Service.makeMessageParticles(entity.position.x, entity.position.y, healingAmount, color.green)	
end function

basicHealingPotion = new HealingPotionItem
basicHealingPotion.name = "basic healing potion"
basicHealingPotion.numDice = 2
basicHealingPotion.numSides = 4
basicHealingPotion.modifier = 2

greaterHealingPotion = new HealingPotionItem
greaterHealingPotion.name = "greater healing potion"
greaterHealingPotion.numDice = 4
greaterHealingPotion.numSides = 4
greaterHealingPotion.modifier = 4

superiorHealingPotion = new HealingPotionItem
superiorHealingPotion.name = "superior healing potion"
superiorHealingPotion.numDice = 8
superiorHealingPotion.numSides = 4
superiorHealingPotion.modifier = 8
