import "actions"
import "point"

Behavior = {}

Behavior.act = function()
	return actions.EntityAction.wait
end function

Behavior.makeRandomWalk = function()
	b = new Behavior
	b.currentDirection = point.Point.make(0, 0)

	b.chooseNewDirection = function(entity)
		dx = floor(rnd() * 3) - 1
		dy = 0
		if dx == 0 then
			dy = floor(rnd() * 3) - 1
		end if
		self.currentDirection.x = dx
		self.currentDirection.y = dy
	end function

	b.act = function(entity)
		action = actions.EntityAction.wait
		if rnd() > 0.5 then
			self.chooseNewDirection()
		end if

		if self.currentDirection.x != 0 or self.currentDirection.y != 0 then
			return actions.EntityAction.walk(self.currentDirection) 
		else
			return actions.EntityAction.wait
		end if
	end function

	return b
end function

Keys = { "left": 17,
		 "right": 18,
		 "up": 19,
		 "down": 20 }

Behavior.makeUserInput = function()
	b = new Behavior

	b.act = function(entity)
		delta = point.Point.make(0, 0)
		k = key.get.code
		if k == Keys.up then
			delta.y = 1
		else if k == Keys.down then
			delta.y = -1
		else if k == Keys.left then
			delta.x = -1
		else if k == Keys.right then
			delta.x = 1
		end if

		if delta.x != 0 or delta.y != 0 then
			return actions.EntityAction.walk(delta)
		else
			return actions.EntityAction.wait
		end if
	end function

	return b
end function