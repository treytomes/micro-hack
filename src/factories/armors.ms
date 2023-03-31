leatherArmor = new armor.Armor
leatherArmor.init("leather armor", 1, 0.4)
leatherArmor.armorClass = 2
leatherArmor.weight = 15
leatherArmor.goldValue = 10
leatherArmor.absorptionDice = math.Dice.make(1, 6)
leatherArmor.description = "Made of soft leather, this armor is light and flexible."

ringMail = new armor.Armor
ringMail.init("ring mail", 2, 0.3)
ringMail.armorClass = 4
ringMail.weight = 30
ringMail.goldValue = 100
ringMail.absorptionDice = math.Dice.make(1, 6)
ringMail.description = "A coat of interlocking metal rings, this armor is durable and provides good protection."

scaleMail = new armor.Armor
scaleMail.init("scale mail", 4, 0.15)
scaleMail.armorClass = 5
scaleMail.weight = 45
scaleMail.goldValue = 50
scaleMail.absorptionDice = math.Dice.make(1, 8)
scaleMail.description = "Made of overlapping scales of metal or leather, this armor provides good protection while still allowing for some flexibility."

chainMail = new armor.Armor
chainMail.init("chain mail", 4, 0.15)
chainMail.armorClass = 6
chainMail.weight = 75
chainMail.goldValue = 150
chainMail.absorptionDice = math.Dice.make(1, 8)
chainMail.description = "A shirt of interlocking metal rings, this armor provides good protection but can be heavy and restrictive."

splintMail = new armor.Armor
splintMail.init("splint mail", 6, 0.1)
splintMail.armorClass = 7
splintMail.weight = 200
splintMail.goldValue = 80
splintMail.absorptionDice = math.Dice.make(1, 8)
splintMail.description = "Made of strips of metal or other rigid material, this armor is heavy but provides excellent protection."

bandedMail = new armor.Armor
bandedMail.init("banded mail", 8, 0.05)
bandedMail.armorClass = 6
bandedMail.weight = 75
bandedMail.goldValue = 90
bandedMail.absorptionDice = math.Dice.make(1, 8)
bandedMail.description = "Made of metal bands fastened to a leather backing, this armor is lighter than plate mail but still provides good protection."

plateMail = new armor.Armor
plateMail.init("plate mail", 10, 0.02)
plateMail.armorClass = 8
plateMail.weight = 450
plateMail.goldValue = 400
plateMail.absorptionDice = math.Dice.make(1, 8)
plateMail.description = "Made of shaped and fitted metal plates, this armor is heavy and restrictive but provides excellent protection."

studdedLeather = new armor.Armor
studdedLeather.init("studded leather", 1, 0.35)
studdedLeather.armorClass = 3
studdedLeather.weight = 20
studdedLeather.goldValue = 30
studdedLeather.absorptionDice = math.Dice.make(1, 6)
studdedLeather.description = "Made of tough but flexible leather studded with metal rivets, this armor provides good protection while allowing for a greater range of movement."

paddedArmor = new armor.Armor
paddedArmor.init("padded armor", 1, 0.25)
paddedArmor.armorClass = 1
paddedArmor.weight = 10
paddedArmor.goldValue = 5
paddedArmor.absorptionDice = math.Dice.const(0)
paddedArmor.description = "Consisting of layers of cloth and stuffing, padded armor provides moderate protection against cuts and bludgeoning attacks, but is less effective against piercing attacks."

robe = new armor.Armor
robe.init("robe", 1, 0.2)
robe.armorClass = 0
robe.weight = 5
robe.goldValue = 10
robe.absorptionDice = math.Dice.const(0)
robe.description = "A simple garment made of lightweight fabric, the robe provides very little protection, but is comfortable to wear and allows for a full range of movement."

cloak = new armor.Armor
cloak.init("cloak", 1, 0.3)
cloak.armorClass = 1
cloak.weight = 5
cloak.goldValue = 10
cloak.absorptionDice = math.Dice.const(0)
cloak.description = "A long piece of fabric worn over the shoulders and fastened at the neck, the cloak provides minimal protection against the elements and can be used to hide small objects or weapons."
