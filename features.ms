// Feature flags.
// Controls controversial mechanics.

import "items"
import "weapons"

// If this is true, every time you begin an attack your opponent will be allowed to roll for initiative.  And vice-versa.
ALWAYS_COUNTER_ATTACK = false

// If this is false, the entire map will always be visible.
ENABLE_FOV = true

PLAYER_INITIAL_WEAPON = weapons.shortSword
PLAYER_INITIAL_INVENTORY = [
	items.basicHealingPotion, items.basicHealingPotion, items.basicHealingPotion, items.basicHealingPotion, items.basicHealingPotion,
	items.greaterHealingPotion, items.greaterHealingPotion, items.greaterHealingPotion,
	items.superiorHealingPotion ]
