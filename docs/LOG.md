# Next

## Updates
* Examine window compresses to only the description if only 1 item is on the tile you select.
* Improved map renderer performance.
* 1/20 chance of a critical hit in the attack algorithm.

# 20230406

## Updates

* Remove the "Not equipped" text from the inventory UI.
* Entity inventory has been upgraded from a list to an Inventory object.
* Inventory slots are now composed of ItemStack objects in place of raw Items.
* The overworld has arrived!  Read the sign for more info.
* rangeOfVision = perception / 2.
* Use the "e" key followed by an arrow to examine the tile in that direction.
* Use the ";" key to activate a selection cursor.  Move the cursor around to inspect a tile.  `enter` for more details. 
* Used page flipping to get a good performance boost, and knock out the jagged entity movement bug.
* Bonus: The game is almost playable from the browser!

## Known Bugs

* If you crash the game then immediately restart it, it gets really laggy and has rendering artifacts.
    * Probably related to page flipping.

# 20230331

## Updates

* Rats infest the top levels of the dungeon.  Kobolds appear in increasing number as you go down.
* Rats are relatively weak, but they'll still nibble you to death if you're not careful!
* Kobolds have been un-nerfed.  They are now properly armed.
* Tweaked the stats a bit.  Also new enemies should be easier to make.
* When you pick up an item, you will get the item under your feet.
* Armor is now a thing!  I've tweaked the attack algorithm to account for armor AC and damage absorption.
* Every item in the game now has a level and rarity that is used to control loot spawning.  The highest level item can only be found at level 10 or lower.
* Fixed a bug in the particle renderer.  Using page flipping now, so it should be a bit smoother.
* Unarmed damage dice increased from 1d1 to 1d4.
* 50% chance that *every room* will have a prize!
* You only get 1 health potion for free.  Go find the rest yourself.
* Some performance improvements.

## Strategies

* Rest every chance you get.  Definitely rest before going down a level.

# 20230330

## Updates

* Using ensureImport, which should eventually clean up the import mass in main.ms.
    * Removed the reference to `tc`.  It wasn't needed, and was apparently mucking up my scope.
* Another big refactoring to accomodate the CI/CD pipeline.
* Game is published to [itch.io](https://treytomes.itch.io/micro-hack)!
* Allow multiple keys per keybindings.
* Inventory UI will show the tile icons.
* Colors are micro-managed a bit more.
* Particles can use floating-point velocities.
* Notification and particles when you level up.
* Increase in HP when you level up.
* You can go down *and back up* the stairs!  Nothing new on lower levels yet though.

# 20230325

## Updates

* Use the micro-man tile to represent the player.
* So much code refactoring.  Factory methods make a lot more sense now.
* Every item has a gold value, weight, and description.
* Kobolds won't always politely wait in line to beat you up.  If they get impatient they'll just go around.
* The inventory UI is a lot more useful now.  Use the arrow keys and `enter` (`keybindings.select`) to navigate.

# 20230321

Goals:
1. Don't die.
2. Loot the loot room and equip the stuff.
3. Get your character to level 2.
4. Find the stairs to the next floor.  Which don't go anywhere yet.

Best strategy for the latest version:
* Find the loot room as soon as possible!
* Rest every chance you get to recover HP.
* Try to lure kobolds one at a time by standing just at the range of their vision, then backing off when they start chasing you.
* Remember that you have to pick up *and then use* a weapon or shield to equip it.
* Due to limitations in the current UI, you'll want to drop your currently equipped item before picking up a new one.

## Updates
* Implemented shields.
* The player starts with a buckler.  Kobolds could start with a variety of shields, or no shield.
* Stairs up and down have been added, but they don't go anywhere yet.
* There's a loot room hiding in the level with some sweet l00tz.  Go find it!
* The UI no longer flips.
* I've nerfed the kobold equipment just a bit.  They'll be back to their fully-equipped glory soon.

## Known Bugs

* There's a timing issue if you try to open your inventory when an enemy is about to attack and you're almost dead.  You might find that you die while opening the UI.
* When you pick up an item in the loot room, you will sometimes pick up a distant item before the one under your feet.

# 20230320

* Monsters will respect their range of vision while seeking the player.
* Kobolds will now receive a random weapon.
* You can drop anything from your inventory onto the map with the "d" key.
* You can pick up any item you see on the map with the "g" key.
* Kobolds will drop their stuff when they die.
* Access your inventory with "i", then use 0-9 to use an item.
* Use a weapon to equip it.
* Review keybindings.ms if you forget what keys you can use.

## Known Bugs
* You can't select any items after the 0-9.

# 20230317

* XP and level is now being tracked.  Leveling up won't gain you anything yet.
* Kobolds will hunt you down.
* If the kobolds can't hunt you down, they'll spend their time gathering together in packs.
* The kobolds will wander randomly as a last result if they get bored.
* They demo map now has a lot more kobolds to beat up.  In fact, there are exactly enough kobolds for you to reach level 2 if you manage to kill them all.  Good luck.
* Disabled automatic counter-attacks.  It's hiding behind a feature flag now.
* Healing is now harder.  A rest counter increments every time you rest.  Roll a d20; if the result is less than the # rest turns + your constitution modifier you get +1 HP.
* Simple inventory system.  Press `i` to open the inventory window.  Select a number to consume that item.  Press any other key to close the window.
* The initial player items are listed out in `features.ms`.

# 20230316

* Rooms have doors.
* The map will scroll, always keeping the player in the center of the screen.
* Now the level size is 64x64.

# 20230315

* Better FOV calculation.
* Replaced the arena with a random dungeon generator.
    * Rooms are placed around the map at random.
    * Each room can be a different size.
    * Each room is connect to the previous room by a hallway.
* Walls and floors are brown now.

# 20230314

* Implemented field-of-view.
* Map tracks tiles that are visible, or that have been seen already.
* Entity now has perception and rangeOfVision attributes.
* Cleaned up the timing issue when entities die.
* Particles have slightly better performance.

# 20230312

* Implemented a battle system.
* Implemented a HUD with a message log and status bar.
* HUD will flip based on which side of the screen the player is on.

# 20230310

* A simple level is generated with floors and walls.
* The player can walk around.
* If you run into a wall you'll be stopped and a sound will play.
* The 2 entity types (player, kobold) are both treated equally by the game loop.
* Entities have behaviors, behaviors generate actions.  Ultimately every action will have a cost.
* The kobolds will wander the map.  You can't really interact with them yet.
