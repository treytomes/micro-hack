unarmed = new weapon.Weapon
unarmed.init("unarmed")
unarmed.damageDice = math.Dice.make(1, 1)

// TODO: piercing damage, weight, dual-wield
dagger = new weapon.Weapon
dagger.init("dagger")
dagger.tile = tile.make("-", color.gray, color.black)
dagger.damageDice = math.Dice.make(1, 4)

// TODO: piercing damage
shortSword = new weapon.Weapon
shortSword.init("short sword")
shortSword.tile = tile.make("\\", color.gray, color.black)
shortSword.damageDice = math.Dice.make(1, 6)

// TODO: slashing damage
longSword = new weapon.Weapon
longSword.init("long sword")
longSword.tile = tile.make("/", color.gray, color.black)
longSword.damageDice = math.Dice.make(1, 8)
