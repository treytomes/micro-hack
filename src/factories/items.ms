basicHealingPotion = new healingPotionItem.HealingPotionItem
basicHealingPotion.init("healing potion", 1, 0.25)
basicHealingPotion.dice = math.Dice.make(2, 4, 2)
basicHealingPotion.weight = 0.5
basicHealingPotion.goldValue = 50
basicHealingPotion.description = "This potion is a bright red liquid that restores some of the drinker's vitality."

greaterHealingPotion = new healingPotionItem.HealingPotionItem
greaterHealingPotion.init("greater healing potion", 5, 0.15)
greaterHealingPotion.dice = math.Dice.make(4, 4, 4)
greaterHealingPotion.weight = 0.5
greaterHealingPotion.goldValue = 200
greaterHealingPotion.description = "This potion is a dark red liquid that has a slightly bitter taste."

superiorHealingPotion = new healingPotionItem.HealingPotionItem
superiorHealingPotion.init("superior healing potion", 10, 0.08)
superiorHealingPotion.dice = math.Dice.make(8, 4, 8)
superiorHealingPotion.weight = 0.5
superiorHealingPotion.goldValue = 1000
superiorHealingPotion.description = "This potion is a bright pink liquid that radiates warmth when held."

supremeHealingPotion = new healingPotionItem.HealingPotionItem
supremeHealingPotion.init("supreme healing potion", 15, 0.03)
supremeHealingPotion.dice = math.Dice.make(10, 4, 20)
supremeHealingPotion.weight = 0.5
supremeHealingPotion.goldValue = 5000
supremeHealingPotion.description = "This potion is a sparkling golden liquid that glows with divine energy."
