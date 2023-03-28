Behavior = {}
Behavior.willAttackSameRace = false

Behavior.isEntityAtPosition = function(entity, map, position)
	hitEntity = map.getEntityAt(position) 
	if hitEntity != null then
		if self.isAlly(entity, hitEntity) then
			return true
		else
			// They aren't friends, so keep walking like they're not even there.
			return false
		end if
	else
		return false
	end if
end function

Behavior.moveTowards = function(entity, map, position)
	delta = position.subtract(entity.position).sign()

	// The entity can theoretically see the player.
	// I'm allowing monsters to "see" through walls.  It makes up for the lack of a sense of smell and hearing.

	if delta.x != 0 and not map.blocksMovement(entity.position.x + delta.x, entity.position.y) then
		deltaX = point.unitX.scale(delta.x)
		newPos = entity.position.add(deltaX)
		if not self.isEntityAtPosition(entity, map, newPos) then
			return actions.walk(deltaX)
		end if
	end if
	if delta.y != 0 and not map.blocksMovement(entity.position.x, entity.position.y + delta.y) then
		deltaY = point.unitY.scale(delta.y)
		newPos = entity.position.add(deltaY)
		if not self.isEntityAtPosition(entity, map, newPos) then
			return actions.walk(deltaY)
		end if
	end if

	return null
end function

Behavior.findNearbyEntities = function(entity, map)
	found = []
	radius = entity.rangeOfVision ^ 2

	for e in map.entities
		if e == entity then
			continue
		end if
		if e == null then
			continue
		end if

		delta = entity.position.subtract(e.position)
		dist = delta.x ^ 2 + delta.y ^ 2
		if dist <= radius then
			found.push(e)
		end if
	end for
	return found
end function

Behavior.isAlly = function(source, target)
	return source.race == target.race and not self.willAttackSameRace
end function

Behavior.act = function(entity, map)
	return actions.wait()
end function

Behavior.onEntityCollision = function(sourceEntity, targetEntity, map)
	// Don't panic; this one is intentionally empty.
end function
