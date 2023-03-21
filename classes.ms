
ClassDescription = {}
ClassDescription.name = "classless"
ClassDescription.hpDice = math.Dice.make(1, 10)
ClassDescription.dexterityDice = math.Dice.make(1, 20)
ClassDescription.strengthDice = math.Dice.make(1, 20)
ClassDescription.constitutionDie = math.Dice.make(3, 6)

ClassDescription.rollForStrength = function()
	return self.strengthDice.roll()
end function

ClassDescription.rollForDexterity = function()
	return self.dexterityDice.roll()
end function

ClassDescription.rollForHP = function()
	return self.hpDice.roll()
end function

ClassDescription.rollForConstitution = function()
	return self.constitutionDie.roll()
end function

FighterClassDescription = new ClassDescription
FighterClassDescription.name = "fighter"
FighterClassDescription.hpDice = math.Dice.make(1, 10)

// TODO: Change this to match other factory lists.
ClassDescriptions = {
	"fighter": new FighterClassDescription,
}
