Race = new Object
Race.name = "n/a"
Race.baseArmorClass = 0

Race.baseArmorClass = 0
Race.hp = math.Dice.const(1) // Default to 1 so the engine doesn't mark it as dead.
Race.strength = math.Dice.const(0)
Race.dexterity = math.Dice.const(0)
Race.constitution = math.Dice.const(0)
Race.intelligence = math.Dice.const(0)
Race.wisdom = math.Dice.const(0)
Race.charisma = math.Dice.const(0)

Race.init = function(name)
	super.init()
	self.name = name
	return self
end function
