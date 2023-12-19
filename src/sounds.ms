cache = {}
cache.pop = file.loadSound("/sys/sounds/pop.wav")

pop = function()
	cache.pop.play()
end function
