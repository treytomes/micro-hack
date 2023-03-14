import "math"
import "point"
import "rect"

// Calculates the hero's field of view of the dungeon.
//
// Learned of this algorithm here: http://journal.stuffwithstuff.com/2015/09/07/what-the-hero-sees/
FieldOfVisionCalculator = {}
FieldOfVisionCalculator.make = function(width, height)
	c = new FieldOfVisionCalculator
	c.width = width
	c.height = height
	c._shadows = Shadows.make()
	c.clear()
	return c
end function

FieldOfVisionCalculator.clear = function()
	self._visibility = []
	for y in range(0, self.height - 1)
		row = []
		for x in range(0, self.width - 1)
			row.push(false)
		end for
		self._visibility.push(row)
	end for
end function

// Update the visible flags given the hero's position.
FieldOfVisionCalculator.refresh = function(x, y, distance, map)
	self.clear()

	minX = x - distance
	maxX = x + distance
	minY = y - distance
	maxY = y + distance
	if minX < 0 then
		minX = 0
	end if
	if maxX >= self.width then
		maxX = self.width - 1
	end if
	if minY < 0 then
		minY = 0
	end if
	if maxY >= self.height then
		maxY = self.height - 1
	end if

	start = point.Point.make(x, y)

	// Sweep through the octants.
	for octant in range(0, 7)
		self.refreshOctant(map, minX, maxX, minY, maxY, start, octant)
	end for

	// Mark the starting position as visible.
	self._visibility[start.y][start.x] = true

	for y in range(0, map.height - 1)
		for x in range(0, map.width - 1)
			map.tiles[y][x].isCurrentlyVisible = self._visibility[y][x]
			if self._visibility[y][x] then
				map.tiles[y][x].hasBeenVisited = true
			end if
		end for
	end for
end function

FieldOfVisionCalculator.refreshOctant = function(map, minX, maxX, minY, maxY, start, octant)
	numExplored = 0
	rowInc = point.Point.zero
	colInc = point.Point.zero

	// Figure out which direction to increment based on the octant. Octant 0
	// starts at 12 - 2 o'clock, and octants proceed clockwise from there.
	if octant == 0 then
		rowInc = point.Point.unitY.negate
		colInc = point.Point.unitX
	else if octant == 1 then
		rowInc = point.Point.unitX
		colInc = point.Point.unitY.negate
	else if octant == 2 then
		rowInc = point.Point.unitX
		colInc = point.Point.unitY
	else if octant == 3 then
		rowInc = point.Point.unitY
		colInc = point.Point.unitX
	else if octant == 4 then
		rowInc = point.Point.unitY
		colInc = point.Point.unitX.negate
	else if octant == 5 then
		rowInc = point.Point.unitX.negate
		colInc = point.Point.unitY
	else if octant == 6 then
		rowInc = point.Point.unitX.negate
		colInc = point.Point.unitY.negate
	else if octant == 7 then
		rowInc = point.Point.unitY.negate
		colInc = point.Point.unitX.negate
	end if

	self._shadows = Shadows.make()

	bounds = rect.Rectangle.make(minX, minY, maxX - minX + 1, maxY - minY + 1)
	fullShadow = false

	// Sweep through the rows ('rows' may be vertical or horizontal based on the incrementors). Start at row 1 to skip the center position.
	row = 1
	while true
		pos = start.add(rowInc.multiply(row))

		// If we've traversed out of bounds, bail.
		// Note: this improves performance, but works on the assumption that the starting tile of the FOV is in bounds.
		if not bounds.contains(pos) then
			break
		end if

		for col in range(0, row)
			blocksLight = false
			visible = false
			projection = null

			// If we know the entire row is in shadow, we don't need to be more specific.
			if not fullShadow then
				blocksLight = map.blocksVision(pos.x, pos.y)
				projection = self.getProjection(row, col)
				visible = not self._shadows.contains(projection)
			end if

			// Set the visibility of this tile.
			if self._visibility[pos.y][pos.x] != visible then
				self._visibility[pos.y][pos.x] = visible
				if visible then
					numExplored += 1
				end if
			end if

			// Add any opaque tiles to the shadow map.
			if blocksLight then
				fullShadow = self._shadows.insert(projection)
			end if

			// Move to the next column.
			pos = pos.add(colInc)

			// If we've traversed out of bounds, bail on this row.
			// Note: this improves performance, but works on the assumption that the starting tile of the FOV is in bounds.
			if not bounds.contains(pos) then
				break
			end if
		end for

		row += 1
	end while

	return numExplored
end function

// Creates a [Shadow] that corresponds to the projected silhouette of the
// given tile. This is used both to determine visibility (if any of the
// projection is visible, the tile is) and to add the tile to the shadow map.
//
// The maximal projection of a square is always from the two opposing
// corners. From the perspective of octant zero, we know the square is
// above and to the right of the viewpoint, so it will be the top left and
// bottom right corners.
FieldOfVisionCalculator.getProjection = function(row, col)
	// The top edge of row 0 is 2 wide.
	topLeft = col / (row + 2)

	// The bottom edge of row 0 is 1 wide.
	bottomRight = (col + 1) / (row + 1)

	return Shadow.make(topLeft, bottomRight)
end function


// Represents the 1D projection of a 2D shadow onto a normalized line.  In other words, a range from 0.0 to 1.0.
Shadow = {}

Shadow.make = function(start, stop)
	s = new Shadow
	s.start = start
	s.stop = stop
	return s
end function

/// Returns `true` if [other] is completely covered by this shadow.
Shadow.contains = function(other)
	return self.start <= other.start and self.stop >= other.stop
end function


Shadows = {}

Shadows.make = function()
	lst = new Shadows
	lst.data = []
	return lst
end function

Shadows.contains = function(projection)
	if self.data.len > 0 then
		for s in self.data
			if s.contains(projection) then
				return true
			end if
		end for
	end if
	return false
end function

// Add [shadow] to the list of non-overlapping shadows.  May merge one or more shadows.
Shadows.insert = function(shadow)
	if shadow == null then
		return
	end if

	if self.data.len == 0 then
		self.data.push(shadow)
		return
	end if

	// Figure out where to slot the new shadow in the sorted list.
	index = 0
	for index in range(0, self.data.len - 1)
		// Stop when we hit the insertion point.
		if self.data[index].start >= shadow.start then
			break
		end if
	end for

	// The new shadow is going here. See if it overlaps the previous or next.
	overlapsPrev = ((index > 0) and (self.data[index - 1].stop > shadow.start))
	overlapsNext = ((index < self.data.len) and (self.data[index].start < shadow.stop))

	// Insert and unify with overlapping shadows.
	if overlapsNext then
		if overlapsPrev then
			// Overlaps both, so unify one and delete the other.
			self.data[index - 1].stop = math.max(self.data[index - 1].stop, self.data[index].stop)
			self.data = self.data[:index - 1] + self.data[:index]
		else
			// Just overlaps the next shadow, so unify it with that.
			self.data[index].start = math.min(self.data[index].start, shadow.start)
		end if
	else
		if overlapsPrev then
			// Just overlaps the previous shadow, so unify it with that.
			self.data[index - 1].stop = math.max(self.data[index - 1].stop, shadow.stop)
		else
			// Does not overlap anything, so insert.
			self.data = self.data[:index] + [ shadow ] + self.data[index:]
		end if
	end if

	// See if we are now shadowing everything.
	return self.data.len == 1 and self.data[0].start == 0 and self.data[0].stop == 1
end function
