// Buckler: This small shield is held in the hand and provides a +1 bonus to AC. It has the advantage of not impeding movement or requiring proficiency.
buckler = new shield.Shield
buckler.init("buckler")
buckler.armorClass = 1
buckler.weight = 2
buckler.goldValue = 5

// Shield: The most common type of shield, this is strapped to the forearm and provides a +2 bonus to AC. It requires proficiency to use and may impose disadvantage on certain ability checks, such as those involving dexterity or strength.
basicShield = new shield.Shield
basicShield.init("shield")
basicShield.armorClass = 2
basicShield.weight = 6
basicShield.goldValue = 10

// Tower Shield: This large, heavy shield provides a +3 bonus to AC but also imposes disadvantage on attack rolls while equipped. It requires proficiency to use and is typically reserved for characters with high strength scores.
towerShield = new shield.Shield
towerShield.init("tower shield")
towerShield.armorClass = 3
towerShield.weight = 45
towerShield.goldValue = 30

smallWoodenShield = new shield.Shield
smallWoodenShield.init("small wooden shield")
smallWoodenShield.armorClass = 1
smallWoodenShield.weight = 3
smallWoodenShield.goldValue = 1

scaleShield = new shield.Shield
scaleShield.init("scale shield")
scaleShield.armorClass = 2
scaleShield.weight = 5
scaleShield.goldValue = 50

// Spiked shields are spikey.
spikedShield = new shield.Shield
spikedShield.init("spiked shield")
spikedShield.damageDice = math.Dice.make(1, 6)
spikedShield.armorClass = 2
spikedShield.weight = 6
spikedShield.goldValue = 10

hideShield = new shield.Shield
hideShield.init("hide shield")
hideShield.armorClass = 2
hideShield.weight = 6
hideShield.goldValue = 10
