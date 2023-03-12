import "math"

WeaponDescription = {}
WeaponDescription.name = "n/a"
WeaponDescription.numDice = 1
WeaponDescription.numSides = 1
WeaponDescription.rollDice = function()
	return math.rollDice(self.numDice, self.numSides)
end function

UnarmedWeaponDescription = new WeaponDescription
UnarmedWeaponDescription.name = "unarmed"
UnarmedWeaponDescription.numDie = 1
UnarmedWeaponDescription.numSides = 1

ShortSwordWeaponDescription = new WeaponDescription
ShortSwordWeaponDescription.name = "short sword"
ShortSwordWeaponDescription.numDie = 1
ShortSwordWeaponDescription.numSides = 6

WeaponDescriptions = {
	"unarmed": new UnarmedWeaponDescription,
	"shortsword": new ShortSwordWeaponDescription }
