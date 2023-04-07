FieldOfVisionCalculator = {}
FieldOfVisionCalculator.make = function(width, height)
	f = new FieldOfVisionCalculator
	return f
end function

FieldOfVisionCalculator.refresh = function(x, y, radius, map)
	calculateFOV(x, y, radius, map)
end function

calculateLineOfSight = function(map, x0, y0, x1, y1)
	dx = abs(x1 - x0)
	dy = abs(y1 - y0)
	if x0 < x1 then
		sx = 1
	else
		sx = -1
	end if
	if y0 < y1 then
		sy = 1
	else
		sy = -1
	end if
	err = dx - dy

	x = x0
	y = y0
	while x != x1 or y != y1
		// Set the seen and visible flags on the current tile.
		tile = map.getTile(x, y)
		tile.hasBeenVisited = true
		tile.isCurrentlyVisible = true
		if tile.blocksVision and not (x == x0 and y == y0) then
			break
		end if

		// Calculate the next tile in the line-of-sight.
		e2 = 2 * err
		if e2 > -dy then
			err -= dy
			x += sx
		end if
		if e2 < dx then
			err += dx
			y += sy
		end if
	end while
end function

// Reset visibility flags for all tiles in the map.
hideRegion = function(x, y, radius, map)
	for y0 in range(y - radius - 1, y + radius + 1)
		for x0 in range(x - radius - 1, x + radius + 1)
			map.getTile(x0, y0).isCurrentlyVisible = false
		end for
	end for
end function

calculateFOV = function(x, y, radius, map)
	if features.ENABLE_FOV then
		squared_radius = radius ^ 2 // Pre-calculate squared radius for efficiency.
		hideRegion(x, y, radius + 1, map)

		// Set the "visible" flag on the player's tile.
		map.getTile(x, y).isCurrentlyVisible = true

		// Iterate through all tiles within the field-of-view radius.
		for y1 in range(y - radius, y + radius)
			for x1 in range(x - radius, x + radius)
				dx = x1 - x
				dy = y1 - y
				if dx ^ 2 + dy ^ 2 <= squared_radius then
					calculateLineOfSight(map, x, y, x1, y1)
				end if
			end for
		end for
	end if
end function
