makeFloor = function()
	return tile.make(".", Color.brown.dark, Color.black, false, false).setName("floor")
end function

makeGrass = function()
	return tile.make(".", Color.green.dark, Color.green.darker, false, false).setName("grass")
end function

makeMountain = function()
	return tile.make("#", Color.gray.darker.darker, Color.gray.dark.dark, true, true).setName("mountain")
end function

makeStairsUp = function()
	return tile.make("<", Color.brown.dark, Color.black, false, false).setName("stairs up")
end function

makeStairsDown = function()
	return tile.make(">", Color.brown.dark, Color.black, false, false).setName("stairs down")
end function

makeWall = function()
	return tile.make("#", Color.brown, Color.black, true, true).setName("wall")
end function

makeDoor = function()
	return tile.make("+", Color.black, Color.brown, false, true).setName("door")
end function

makeHidden = function()
	return tile.make("#", Color.black, Color.gray, true, true).setName("hidden")
end function
