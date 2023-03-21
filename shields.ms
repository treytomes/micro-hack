Shield = new weapons.Weapon
Shield.armorClass = 0
Shield.damageDice = math.Dice.make(0, 0)
Shield.tile = tile.make(")", color.aqua, color.black)

// TODO: Every item needs a weight and gold value.

Shield.str = function()
	if self.damageDice.numDice == 0 then
		return self.name + " (+" + self.armorClass + ")"
	else
		return self.name + " (+" + self.armorClass + ", " + self.damageDice.str() + ")"
	end if
end function

Shield.use = function(entity)
	entity.shield = self
end function

// Buckler: This small shield is held in the hand and provides a +1 bonus to AC. It has the advantage of not impeding movement or requiring proficiency.
buckler = new Shield
buckler.name = "buckler"
buckler.armorClass = 1
buckler.weight = 2
buckler.goldValue = 5

// Shield: The most common type of shield, this is strapped to the forearm and provides a +2 bonus to AC. It requires proficiency to use and may impose disadvantage on certain ability checks, such as those involving dexterity or strength.
shield = new Shield
shield.name = "shield"
shield.armorClass = 2
shield.weight = 6
shield.goldValue = 10

// Tower Shield: This large, heavy shield provides a +3 bonus to AC but also imposes disadvantage on attack rolls while equipped. It requires proficiency to use and is typically reserved for characters with high strength scores.
towerShield = new Shield
towerShield.name = "tower shield"
towerShield.armorClass = 3
towerShield.weight = 45
towerShield.goldValue = 30

smallWoodenShield = new Shield
smallWoodenShield.name = "small wooden shield"
smallWoodenShield.armorClass = 1
smallWoodenShield.weight = 3
smallWoodenShield.goldValue = 1

scaleShield = new Shield
scaleShield.name = "scale shield"
scaleShield.armorClass = 2
scaleShield.weight = 5
scaleShield.goldValue = 50

// Spiked shields are spikey.
spikedShield = new Shield
spikedShield.name = "spiked shield"
spikedShield.damageDice = math.Dice.make(1, 6)
spikedShield.armorClass = 2
spikedShield.weight = 6
spikedShield.goldValue = 10

hideShield = new Shield
hideShield.name = "hide shield"
hideShield.armorClass = 2
hideShield.weight = 6
hideShield.goldValue = 10
