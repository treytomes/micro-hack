human = (new race.Race).init("human")
human.baseArmorClass = 10
human.hp = math.Dice.make(1, 8)
human.strength = math.Dice.const(8)
human.dexterity = math.Dice.const(10)
human.constitution = math.Dice.const(10)
human.intelligence = math.Dice.const(10)
human.wisdom = math.Dice.const(10)
human.charisma = math.Dice.const(10)

kobold = (new race.Race).init("kobold")
kobold.baseArmorClass = 12
kobold.hp = math.Dice.const(5)
kobold.strength = math.Dice.const(7)
kobold.dexterity = math.Dice.const(15)
kobold.constitution = math.Dice.const(9)
kobold.intelligence = math.Dice.const(8)
kobold.wisdom = math.Dice.const(7)
kobold.charisma = math.Dice.const(8)

// If the rat has any natural armor, such as scales or a thick hide, its AC may be higher
rat = (new race.Race).init("rat")
rat.baseArmorClass = 10
rat.hp = math.Dice.const(1)
rat.strength = math.Dice.const(2)
rat.dexterity = math.Dice.const(11)
rat.constitution = math.Dice.const(10)
rat.intelligence = math.Dice.const(2)
rat.wisdom = math.Dice.const(10)
rat.charisma = math.Dice.const(2)

item = (new race.Race()).init("item")
item.hp = math.Dice.const(1)
item.constitution = math.Dice.const(10)
