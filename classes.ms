
ClassDescription = {}
ClassDescription.name = "classless"
ClassDescription.hpDie = [1, 10]
ClassDescription.dexterityDie = [1, 20]
ClassDescription.strengthDie = [1, 20]
ClassDescription.constitutionDie = [3, 6]

ClassDescription.rollForStrength = function()
	return math.rollDice(self.strengthDie[0], self.strengthDie[1])
end function

ClassDescription.rollForDexterity = function()
	return math.rollDice(self.dexterityDie[0], self.dexterityDie[1])
end function

ClassDescription.rollForHP = function()
	return math.rollDice(self.hpDie[0], self.hpDie[1])
end function

ClassDescription.rollForConstitution = function()
	return math.rollDice(self.constitutionDie[0], self.constitutionDie[1])
end function

FighterClassDescription = new ClassDescription
FighterClassDescription.name = "fighter"
FighterClassDescription.hpDie = [1, 10]

ClassDescriptions = {
	"fighter": new FighterClassDescription }
