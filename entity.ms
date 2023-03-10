import "actions"
import "point"
import "tile"

Entity = {}

Entity.make = function(pnt)
	e = new Entity
	e.tile = tile.Tile.make("@", color.white, color.black, false, false)
	e.position = pnt
	e.isPlayer = false
	e.behaviors = []
	return e
end function

Entity.draw = function()
	self.tile.draw(self.position.x, self.position.y)
end function

Entity.act = function()
	for b in self.behaviors
		action = b.act(self)
		if action != actions.EntityAction.wait then
			return action
		end if
	end for
	return actions.EntityAction.wait
end function
