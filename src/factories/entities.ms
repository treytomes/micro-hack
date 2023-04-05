// Entity Factory

makePlayer = function()
	t = tile.make(char(57872), Color.white, Color.black, true, false)
	e = (new entity.Entity).init(t, races.human, classes.fighter)

	e.name = "player" //e.race.name

	e.xp = 0
	e.isPlayer = true

	// Give the player some stuff to start with.
	if features.GIVE_INITIAL_INVENTORY then
		for item in settings.PLAYER_INITIAL_INVENTORY
			e.inventory.addItem(item)
		end for
		
		e.weapon = settings.PLAYER_INITIAL_WEAPON
		if e.weapon != null then e.inventory.addItem(e.weapon)

		e.shield = settings.PLAYER_INITIAL_SHIELD
		if e.shield != null then e.inventory.addItem(e.shield)
	end if

	e.behaviors.push(behaviors.makeUserInput())
	e.behaviors.push(behaviors.makeAttackOnCollision())
	return e
end function

makeSign = function(map, pnt, msg)
	t = tile.make("-", Color.white, Color.brown, true, false)
	e = (new entity.Entity).init(t, races.npc, classes.classless, pnt)
	e.description = "The sign reads: ""{0}""".fill(msg)
	e.canBeAttacked = false

	// TODO: Need a priority-based behavior system.  Higher priority behaviors
	// get to go first, then only give way to lower priority behaviors if they
	// return null.
	// This could all rats to seek the player, but not eachother.
	e.behaviors.push(behaviors.makeShowMessage(msg))
	return e
end function

makeRat = function(map)
	t = tile.make("r", Color.gray, Color.black, true, false)
	e = (new entity.Entity).init(t, races.rat, classes.classless, map.findHiddenSpawnPoint())
	e.description = "A small creature darting across the floor. As it scurries away, you get a better look and realize it is a basic rat, with beady eyes and a long, pink tail. Its fur is matted and dirty, and it seems to be searching for scraps of food."
	e.xp = 10

	// TODO: Need a priority-based behavior system.  Higher priority behaviors
	// get to go first, then only give way to lower priority behaviors if they
	// return null.
	// This could all rats to seek the player, but not eachother.
	e.behaviors.push(behaviors.makeSeekPlayer())
	e.behaviors.push(behaviors.makeAttackOnCollision())
	return e
end function

// TODO: Kobolds tend to attack in packs.  Move them to level 2.  Make rats appear on level 1.
makeKobold = function(map)
	t = tile.make("k", Color.orange, Color.black, true, false)
	e = (new entity.Entity).init(t, races.kobold, classes.classless, map.findHiddenSpawnPoint())
	e.xp = 25
	e.description = "A small, reptilian humanoid, standing at about three feet tall. It has scaly, dark brown skin and beady red eyes that dart around nervously. The kobold is dressed in rags and carrying a crude weapon, and it looks up at the player with a mix of curiosity and hostility. Its sharp teeth and claws are visible as it snarls, ready to defend itself if necessary."

	e.weapon = math.selectItemByChance([
		[ weapons.dagger, 0.3 ],
		[ weapons.shortSword, 0.3 ],
		[ null, 0.4 ],
	])
	if e.weapon != null then e.inventory.addItem(e.weapon)

	e.armor = math.selectItemByChance([
		[ null, 0.5 ],
		[ armors.leatherArmor, 0.2 ],
		[ armors.scaleMail, 0.15 ],
		[ armors.chainMail, 0.1 ],
		[ armors.splintMail, 0.04 ],
		[ armors.bandedMail, 0.01 ],
		[ armors.plateMail, 0.05 ],
	])

	e.shield = math.selectItemByChance([
		[ null, 0.3 ],
		[ shields.buckler, 0.2 ],
		[ shields.smallWoodenShield, 0.25 ],
		[ shields.scaleShield, 0.15 ],
		[ shields.spikedShield, 0.05 ],
		[ shields.hideShield, 0.05 ],
	])
	if e.shield != null then e.inventory.addItem(e.shield)

	e.behaviors.push(behaviors.makeSeekPlayer())
	e.behaviors.push(behaviors.makeAttackOnCollision())
	return e
end function

makeItem = function(map, item, spawnPoint=null)
	e = (new entity.Entity).init(item.tile, races.npc, classes.classless, math.coalesce(spawnPoint, map.findSpawnPoint()))
	e.name = item.name
	e.item = item
	e.canBeAttacked = false
	return e
end function
