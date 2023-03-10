import "point"
import "sounds"

EntityAction = {}

EntityAction.wait = function()
	action = new EntityAction
	action.apply = function(entity, map)
		entity.draw()
	end function
	return action
end function

EntityAction.walk = function(delta)
	action = new EntityAction
	action.delta = delta
	action.apply = function(entity, map)
		if map.tiles[entity.position.y + self.delta.y][entity.position.x + self.delta.x].blocksMovement then
			if entity.isPlayer then
				sounds.Sounds.pop()
			end if
		else
			map.drawTile(entity.position.x, entity.position.y)
			entity.position.add(self.delta)
			entity.draw()
		end if
	end function
	return action
end function
