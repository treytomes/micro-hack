World = {}
World.player = null
World.currentLevel = 0
World.levels = []

World.map = function()
	while self.currentLevel >= self.levels.len
		map = mapgen.MapGenerator.buildLevel(self.levels.len, self.player)
		Service.fov.refresh(map.stairsUp.x, map.stairsUp.y, self.player.rangeOfVision, map)
		World.levels.push(map)
	end while
	return self.levels[self.currentLevel]
end function
