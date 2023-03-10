import "point"
import "sounds"

EntityAction = {}

EntityAction.wait = function()
	action = new EntityAction
	action.apply = function(entity, map)
	end function
	return action
end function

EntityAction.walk = function(dx, dy)
	action = new EntityAction
	action.delta = point.Point.make(dx, dy)
	action.apply = function(entity, map)
		if map.tiles[entity.position.y + self.delta.y][entity.position.x + self.delta.x].blocksMovement then
			sounds.Sounds.pop()
		else
			map.drawTile(entity.position.x, entity.position.y)
			entity.position.add(self.delta)
			entity.draw
		end if
	end function
	return action
end function
