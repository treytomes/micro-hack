basicHealingPotion = new healingPotionItem.HealingPotionItem
basicHealingPotion.init("basic healing potion")
basicHealingPotion.dice = math.Dice.make(2, 4, 2)

greaterHealingPotion = new healingPotionItem.HealingPotionItem
greaterHealingPotion.init("greater healing potion")
greaterHealingPotion.dice = math.Dice.make(4, 4, 4)

superiorHealingPotion = new healingPotionItem.HealingPotionItem
superiorHealingPotion.init("superior healing potion")
superiorHealingPotion.dice = math.Dice.make(8, 4, 8)
