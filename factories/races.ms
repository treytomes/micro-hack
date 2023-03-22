human = new race.Race
human.init("human")
human.baseArmorClass = 10
human.hpDice = math.Dice.make(1, 8)

kobold = new race.Race
kobold.init("kobold")
kobold.baseArmorClass = 10
kobold.hpDice = math.Dice.make(1, 6)
