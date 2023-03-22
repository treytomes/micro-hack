unarmed = new weapon.Weapon
unarmed.init("unarmed")
unarmed.damageDice = math.Dice.make(1, 1)

// TODO: piercing damage, weight, dual-wield
dagger = new weapon.Weapon
dagger.init("dagger")
dagger.tile = tile.make("-", color.gray, color.black)
dagger.damageDice = math.Dice.make(1, 4)
dagger.weight = 1
dagger.goldValue = 2
dagger.description = "A small and lightweight weapon that can be easily concealed. It can be used for both melee attacks and thrown attacks."

// TODO: piercing damage
shortSword = new weapon.Weapon
shortSword.init("short sword")
shortSword.tile = tile.make("\\", color.gray, color.black)
shortSword.damageDice = math.Dice.make(1, 6)
shortSword.weight = 2
shortSword.goldValue = 10
shortSword.description = "A versatile weapon that can be used for both slashing and stabbing attacks. It is small enough to be used with one hand, leaving the other hand free for a shield or another weapon."

// TODO: slashing damage
longSword = new weapon.Weapon
longSword.init("long sword")
longSword.tile = tile.make("/", color.gray, color.black)
longSword.damageDice = math.Dice.make(1, 8)
longSword.weight = 3
longSword.goldValue = 15
longSword.description = "A versatile weapon that is well-suited for both one-handed and two-handed use. It is a well-balanced weapon that can deliver powerful slashing attacks, and it is often favored by knights and other melee fighters."
