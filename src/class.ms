Class = new Object
Class.name = "classless"
Class.hp = math.Dice.zero()
Class.dexterity = math.Dice.zero()
Class.strength = math.Dice.zero()
Class.constitution = math.Dice.zero()
Class.intelligence = math.Dice.zero()
Class.charisma = math.Dice.zero()
Class.wisdom = math.Dice.zero()

Class.init = function(name)
	super.init()
	self.name = name
	return self
end function
