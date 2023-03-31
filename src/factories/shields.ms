// Buckler: This small shield is held in the hand and provides a +1 bonus to AC. It has the advantage of not impeding movement or requiring proficiency.
buckler = new shield.Shield
buckler.init("buckler", 1, 0.4)
buckler.armorClass = 1
buckler.weight = 2
buckler.goldValue = 5
buckler.description = "A small, round shield that can be strapped to the forearm. It is light and easy to maneuver, but it offers only limited protection."

// Shield: The most common type of shield, this is strapped to the forearm and provides a +2 bonus to AC. It requires proficiency to use and may impose disadvantage on certain ability checks, such as those involving dexterity or strength.
basicShield = new shield.Shield
basicShield.init("shield", 1, 0.3)
basicShield.armorClass = 2
basicShield.weight = 6
basicShield.goldValue = 10
basicShield.description = "A large, flat piece of metal or wood that can be strapped to the arm or held in the hand. It is a common and versatile shield that offers good protection."

// Tower Shield: This large, heavy shield provides a +3 bonus to AC but also imposes disadvantage on attack rolls while equipped. It requires proficiency to use and is typically reserved for characters with high strength scores.
towerShield = new shield.Shield
towerShield.init("tower shield", 5, 0.05)
towerShield.armorClass = 3
towerShield.weight = 45
towerShield.goldValue = 30
towerShield.description = "A large and heavy shield that provides excellent protection. It is too large to be wielded with one hand, so it is usually strapped to the arm or carried by a shield bearer."

smallWoodenShield = new shield.Shield
smallWoodenShield.init("small wooden shield", 1, 0.3)
smallWoodenShield.armorClass = 1
smallWoodenShield.weight = 5
smallWoodenShield.goldValue = 3
smallWoodenShield.description = "A lightweight and inexpensive shield that provides decent protection. It is often used by novice adventurers or those on a tight budget."

scaleShield = new shield.Shield
scaleShield.init("scale shield", 2, 0.2)
scaleShield.armorClass = 2
scaleShield.weight = 6
scaleShield.goldValue = 50
scaleShield.description = "A shield made of interlocking metal scales that provide excellent protection against slashing attacks."

// Spiked shields are spikey.
spikedShield = new shield.Shield
spikedShield.init("spiked shield", 2, 0.15)
spikedShield.damageDice = math.Dice.make(1, 6)
spikedShield.armorClass = 2
spikedShield.weight = 6
spikedShield.goldValue = 25
spikedShield.description = "A shield with metal spikes on its surface that can be used to deliver piercing attacks. It is a versatile weapon that provides good protection and can also be used offensively."

hideShield = new shield.Shield
hideShield.init("hide shield", 3, 0.15)
hideShield.armorClass = 2
hideShield.weight = 8
hideShield.goldValue = 10
hideShield.description = "A shield made from the hide or skin of an animal. It is a lightweight and inexpensive shield that provides decent protection."
