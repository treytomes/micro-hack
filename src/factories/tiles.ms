makeFloor = function()
	return tile.make(".", Color.brown.dark, Color.black, false, false)
end function

makeStairsUp = function()
	return tile.make("<", Color.brown.dark, Color.black, false, false)
end function

makeStairsDown = function()
	return tile.make(">", Color.brown.dark, Color.black, false, false)
end function

makeWall = function()
	return tile.make("#", Color.brown, Color.black, true, true)
end function

makeDoor = function()
	return tile.make("+", Color.black, Color.brown, false, true)
end function

makeHidden = function()
	return tile.make("#", Color.black, Color.gray, true, true)
end function
