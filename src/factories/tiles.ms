// Colored tiles start at index 24 * 16 + 0.

makeFloor = function()
	// return tile.make(".", Color.brown.dark, Color.black, false, false).setName("floor")
	return tile.make(24 * 16 + 0, Color.white, Color.white, false, false).
		setName("floor").
		setMapColor(Color.brown.dark)
end function

makeGrass = function()
	// return tile.make(".", Color.green.dark, Color.green.darker, false, false).setName("grass")
	return tile.make(24 * 16 + 1, Color.white, Color.white, false, false).
		setName("grass").
		setMapColor(Color.green.dark)
end function

makeHidden = function()
	// return tile.make("#", Color.black, Color.gray, true, true).setName("hidden")
	return tile.make(24 * 16 + 2, Color.white, Color.white, true, true).
		setName("hidden").
		setMapColor(Color.black)
end function

makeMountain = function()
	// return tile.make("#", Color.gray.darker.darker, Color.gray.dark.dark, true, true).setName("mountain")
	return tile.make(24 * 16 + 3, Color.white, Color.white, true, true).
		setName("mountain").
		setMapColor(Color.gray.darker.darker)
end function

makeWall = function()
	// return tile.make("#", Color.brown, Color.black, true, true).setName("wall")
	return tile.make(24 * 16 + 4, Color.white, Color.white, true, true).
		setName("wall").
		setMapColor(Color.brown)
end function

makeDoor = function()
	// return tile.make("+", Color.black, Color.brown, false, true).setName("door")
	return tile.make(24 * 16 + 5, Color.white, Color.white, false, true).
		setName("door").
		setMapColor(Color.black)
end function

makeStairsUp = function()
	// return tile.make("<", Color.brown.dark, Color.black, false, false).setName("stairs up")
	return tile.make(24 * 16 + 6, Color.white, Color.white, false, false).
		setName("stairs up").
		setMapColor(Color.brown.dark)
end function

makeStairsDown = function()
	// return tile.make(">", Color.brown.dark, Color.black, false, false).setName("stairs down")
	return tile.make(24 * 16 + 7, Color.white, Color.white, false, false).
		setName("stairs down").
		setMapColor(Color.brown.dark)
end function