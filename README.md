# µ-hack

Traditional roguelike written for the Mini Micro.

Review the files in the "factories" folder to see what items, weapons, shields, armor, etc. are defined.

Available on itch.io [here](https://treytomes.itch.io/micro-hack)

# Features

## Health Regen

When you begin resting ("r"), a rest timer begins to increment.  Every time you rest a d20 is rolled.  If the result of the d20 is less than the rest count + constitution modifier, you will receive +1 restored HP.

What this means in-game is that the odds of your health being restored increase the longer you rest, with it maxing out to definitely healing after 20 turns at rest.

# Entities

Every entity, includes the player, has a race, class, and weapon.
Each entity also has the following attributes:
* level
* xp
* dexterity
* strength
* constitution
* maxHP
* currentHP
* constitutionModifier
* dexterityModifier
* strengthModifier
* armorClass
* baseAttackBonus
* maxCarryingCapacity
* maxPushCapacity
* weaponDamage

# References
* [MiniScript](https://miniscript.org/)
* [MiniScript Manual](https://miniscript.org/files/MiniScript-Manual.pdf)
* [Mini Micro](https://miniscript.org/wiki/Mini_Micro)
