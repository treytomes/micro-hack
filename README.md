# µ-hack

Traditional roguelike written for the Mini Micro.

Review the files in the "factories" folder to see what items, weapons, shields, armor, etc. are defined.

# Features

## Health Regen

When you begin resting ("r"), a rest timer begins to increment.  Every time you rest a d20 is rolled.  If the result of the d20 is less than the rest count, you will receive +1 restored HP.

What this means in-game is that the odds of your health being restored increase the longer you rest, with it maxing out to definitely healing after 20 turns at rest.

## Automatic Health Regen

I'm not sure whether this is even a good feature to include.
The basic idea is that resting restores health.
I guess it might make more sense to wait more than 1 turn before resting begins to restore health, then have it restore a little bit at a time.
This would have the side-effect that resting when monsters are nearby is dangerous.
Longer rests increase odds of restoring health.  Maybe start by rolling a d20, then a d19, etc down to a d1?  Scoring a 1 on the dice means you get +1 HP? 

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

# Basic Attack Algorithm

1. Determine initiative order: Roll a d20 for each combatant and add their initiative modifier (usually their Dexterity modifier). Sort the results from highest to lowest to determine the order of actions.

2. Begin combat: The combatant with the highest initiative goes first. They can move up to their speed and take one action on their turn, such as attacking with a weapon, casting a spell, or using an ability. If they have multiple attacks or actions available, they can use them as appropriate.

3. Attack roll: To attack with a weapon, the attacker rolls a d20 and adds their attack bonus, which includes their proficiency bonus (if proficient with the weapon) and their Strength or Dexterity modifier (depending on the weapon). If the result is equal to or higher than the target's Armor Class (AC), the attack hits.

4. Damage roll: If the attack hits, the attacker rolls the weapon's damage dice and adds any relevant modifiers (such as their Strength modifier for a melee weapon). The target then subtracts this amount from their hit points (HP).

5. Reaction: The target may have a reaction available to them, which they can use to defend themselves or counterattack. For example, they may be able to use the "Shield" spell to increase their AC, or the "Riposte" maneuver to make an attack of opportunity.

6. Repeat: The combatant with the next highest initiative goes next, and the process repeats until all combatants have taken their turn. Once everyone has acted, the round is over and a new round begins with a new initiative order.

7. End of combat: Combat ends when all enemies are defeated or when one side surrenders or flees.


# References
* [MiniScript](https://miniscript.org/)
* [MiniScript Manual](https://miniscript.org/files/MiniScript-Manual.pdf)
* [Mini Micro](https://miniscript.org/wiki/Mini_Micro)
* [Roguelike Tutorial](https://rogueliketutorials.com/tutorials/tcod/v2/)

