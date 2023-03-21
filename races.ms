RaceDescription = {}
RaceDescription.name = "n/a"
RaceDescription.baseArmorClass = 0

human = new RaceDescription
human.name = "human"
human.baseArmorClass = 10
human.hpDice = math.Dice.make(1, 8)

kobold = new RaceDescription
kobold.name = "kobold"
kobold.baseArmorClass = 10
kobold.hpDice = math.Dice.make(1, 6)
