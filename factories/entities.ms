// Entity Factory

makePlayer = function(map)
	e = new entity.Entity
	e.init(map.stairsUp)
	e.tile.char = char(57872)
	e.isPlayer = true

	e.race = races.human
	e.name = "player" //e.race.name
	e.class = classes.fighter
	
	// Give the player some stuff to start with.
	if features.GIVE_INITIAL_INVENTORY then
		for item in settings.PLAYER_INITIAL_INVENTORY
			e.inventory.push(item)
		end for
		
		e.weapon = settings.PLAYER_INITIAL_WEAPON
		e.inventory.push(e.weapon)

		e.shield = settings.PLAYER_INITIAL_SHIELD
		e.inventory.push(e.shield)
	else
		e.weapon = null
	end if

	e.dexterity = e.class.rollForDexterity()
	e.strength = e.class.rollForStrength()
	e.constitution = e.class.rollForConstitution()
	e.maxHP = e.race.hpDice.roll() + e.class.hpDice.roll() + e.constitutionModifier
	e.currentHP = e.maxHP
	e.perception = 8
	e.xp = 0

	e.behaviors.push(behaviors.Behavior.makeUserInput())
	e.behaviors.push(behaviors.Behavior.makeAttackOnCollision())
	return e
end function

// TODO: Kobolds tend to attack in packs.  Move them to level 2.  Make rats appear on level 1.
makeKobold = function(map)
	e = new entity.Entity
	e.init(map.findHiddenSpawnPoint())
	e.tile.foregroundColor = color.orange
	e.tile.char = "k"

	e.race = races.kobold
	e.name = e.race.name
	e.class = classes.fighter

	e.weapon = math.selectItemByChance([
		[ weapons.dagger, 0.2 ],
		[ null, 0.8 ],
	])
	// TODO: Armed kobolds are too tough for a level 1 player.
	//e.weapon = math.selectItemByChance([
	//	[ weapons.dagger, 0.3 ],
	//	[ weapons.shortSword, 0.3 ],
	//	[ null, 0.4 ],
	//])
	if e.weapon != null then
		e.inventory.push(e.weapon)
	end if

	e.shield = null
	// TODO: Shielded kobolds are too much for a level 1 player.
	//e.shield = math.selectItemByChance([
	//	[ null, 0.3 ],
	//	[ shields.buckler, 0.2 ],
	//	[ shields.smallWoodenShield, 0.25 ],
	//	[ shields.scaleShield, 0.15 ],
	//	[ shields.spikedShield, 0.05 ],
	//	[ shields.hideShield, 0.05 ],
	//])
	if e.shield != null then
		e.inventory.push(e.shield)
	end if

	e.dexterity = e.class.rollForDexterity()
	e.strength = e.class.rollForStrength()
	e.constitution = e.class.rollForConstitution()
	e.maxHP = e.race.hpDice.roll() + e.class.hpDice.roll() + e.constitutionModifier
	e.currentHP = e.maxHP

	// Reduced from 12 to 6.  They were just too hard with that much perception; along with the packing behavior.
	e.perception = 6 // 12

	// You get this much XP for killing the monster.
	e.xp = 25

	e.behaviors.push(behaviors.Behavior.makeSeekPlayer())
	//e.behaviors.push(behaviors.Behavior.makeRandomWalk())
	e.behaviors.push(behaviors.Behavior.makeAttackOnCollision())
	return e
end function

makeItem = function(map, item, spawnPoint=null)
	e = new entity.Entity
	e.init(math.coalesce(spawnPoint, map.findSpawnPoint()))
	e.tile = item.tile
	e.name = item.name
	e.item = item
	e.canBeAttacked = false
	return e
end function
