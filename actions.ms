import "point"

EntityAction = {}

EntityAction.wait = function()
	action = new EntityAction
	action.apply = function(entity)
	end function
	return action
end function

EntityAction.walk = function(dx, dy)
	action = new EntityAction
	action.delta = point.Point.make(dx, dy)
	action.apply = function(entity)
		entity.erase
		entity.position.add(self.delta)
		entity.draw
	end function
	return action
end function
