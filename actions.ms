import "point"
import "sounds"

EntityAction = {}

EntityAction.wait = function()
	action = new EntityAction
	action.apply = function(entity, map)
		oldHP = entity.currentHP
		recoveredHP = entity.class.rollForHP()
		entity.currentHP += recoveredHP
		if entity.currentHP > entity.maxHP then
			entity.currentHP = entity.maxHP
		end if
		delta = entity.currentHP - oldHP
		if delta != 0 then
			Service.makeMessageParticles(entity.position.x, entity.position.y, delta, color.green)
		end if
	end function
	return action
end function

EntityAction.walk = function(delta)
	action = new EntityAction
	action.delta = delta
	action.apply = function(entity, map)
		newPos = point.Point.make(entity.position.x + delta.x, entity.position.y + delta.y)
		if map.tiles[newPos.y][newPos.x].blocksMovement then
			if entity.isPlayer then
				sounds.Sounds.pop()
			end if
		else
			bumpedEntity = map.getEntityAt(newPos)
			if bumpedEntity == null then
				entity.position.add(self.delta)
			else
				entity.onEntityCollision(bumpedEntity)
			end if
		end if
	end function
	return action
end function
