classless = (new class.Class).init("classless")
classless.hp = math.Dice.zero()

fighter = (new class.Class).init("fighter")
fighter.hp = math.Dice.make(1, 10)

// Normally 4d6, then drop the lowest, but this math works just as well on a computer.
fighter.dexterity = math.Dice.make(3, 6)
fighter.strength = math.Dice.make(3, 6)
fighter.constitution = math.Dice.make(3, 6)
fighter.intelligence = math.Dice.make(3, 6)
fighter.charisma = math.Dice.make(3, 6)
fighter.wisdom = math.Dice.make(3, 6)
