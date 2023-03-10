Sounds = {}
Sounds.cache = {}

Sounds.initialize = function()
	self.cache["pop"] = file.loadSound("/sys/sounds/pop.wav")
end function

Sounds.pop = function()
	self.cache["pop"].play
end function