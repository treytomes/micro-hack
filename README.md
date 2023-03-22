# µ-hack

Traditional roguelike written for the Mini Micro.

Use the arrow keys to walk around.  Ram an enemy to begin an attack.  The enemy will have a chance to counter attack.
If you wait a turn (by not moving) you will recover some HP.

Actions are defined in "actions.ms".  Ultimately each action will have an Action Point cost associated with it that will be affected by the entity's speed.
Behaviors are a collection of semi-intelligent chunks that can be run together as a list.  Behaviors affect entity state and can generate actions.

Review the files in the "factories" folder to see what items, weapons, shields, armor, etc. are defined.

# Features

## Health Regen

When you begin resting ("r"), a rest timer begins to increment.  Every time you rest a d20 is rolled.  If the result of the d20 is less than the rest count, you will receive +1 restored HP.

What this means in-game is that the odds of your health being restored increase the longer you rest, with it maxing out to definitely healing after 20 turns at rest.

# Ideas

* The random walking algorithm works fine.  Attach it to a slime monster that will wander around and split from time to time.  Splitting cuts the health in half.  Slime will slowly heal itself.

## Battle Heat

Have a battle heat meter increase every time an attack is made.  Use the heat meter to help decide how much XP the player gets after the battle.  Longer battles (indicating strong / more enemies give me XP.

Use the battle heat value to calculate the Challenge Rating (CR) of the encounter, e.g. XP = 50 + (Encounter CR × 25)

## Automatic Health Regen

I'm not sure whether this is even a good feature to include.
The basic idea is that resting restores health.
I guess it might make more sense to wait more than 1 turn before resting begins to restore health, then have it restore a little bit at a time.
This would have the side-effect that resting when monsters are nearby is dangerous.
Longer rests increase odds of restoring health.  Maybe start by rolling a d20, then a d19, etc down to a d1?  Scoring a 1 on the dice means you get +1 HP? 

# TODO

* Rats should appear on level 1.  Kobolds on level 2.
* Gold should be an entity attribute.
* Kobolds should drop gold.
* Implement armor.
* Add attributes to every item:
    * weight
	* gold value
	* description
* Add a speed attribute and give each action a cost.
* Need more UI.
    * Turn the inventory select UI into a select list.
	* Need a better indicator that something is equipped.
* Implement a BSP map generator.
* Implement a cavern generator.
* Implement a town generator.
* Need NPCs.
	* Create a simple merchant NPC in the starting room.
* XP and level is now being tracked.  What happens when a character levels up?

## Kobold camps

* Designate one room in a dungeon as a kobold camp.
* Decorate the room with "campy"-things.
* Kobolds will randomly spawn in their camp room, as long as the room isn't too crowded.
* The campfire tile should burn anything that steps into it.


# Need to decide
* Should I hide particles if they fall outside the field of view?


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

