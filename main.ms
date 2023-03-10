import "point"
import "entity"
import "actions"

isRunning = true
player = entity.Entity.make(10, 10)

text.clear
player.draw

while isRunning
	action = actions.EntityAction.wait

	delta = point.Point.make(0, 0)
	k = key.get.upper
	if k == "W" then
		action = actions.EntityAction.walk(0, 1)
	else if k == "S" then
		action = actions.EntityAction.walk(0, -1)
	else if k == "A" then
		action = actions.EntityAction.walk(-1, 0)
	else if k == "D" then
		action = actions.EntityAction.walk(1, 0)
	end if
	
	action.apply(player)
end while
