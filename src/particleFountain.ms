ParticleFountain = {}

ParticleFountain.init = function(x, y)
	self.x = x
	self.y = y
	self.particles = []

	self.spawnTimer = 0
	self.lastSpawnTime = 0
	self.spawnRate = 1000

	return self
end function

ParticleFountain.isAlive = function()
	if self.spawnRate > 0 then
		return true
	end if
	for p in self.particles
		if p.isAlive then
			return true
		end if
	end for
	return false
end function

ParticleFountain.isDead = function()
	return not self.isAlive
end function

ParticleFountain.spawn = function()
	self.particles.push(Particle.make(self.x, self.y, 1, 0, 300, 5000, color.white, color.black));
end function

ParticleFountain.draw = function(dsp, deltaTime, map, renderOffset)
	self.spawnTimer += deltaTime
	if self.spawnRate > 0 and (self.spawnTimer - self.lastSpawnTime >= self.spawnRate) then
		self.spawn()
		self.lastSpawnTime = self.spawnTimer
	end if

	n = 0
	while n < self.particles.len
		p = self.particles[n]
		p.update(dsp, deltaTime, map, renderOffset)
		if p.isDead then
			p.erase(dsp)
			self.particles.remove(n)
		else
			n += 1
		end if
	end while
end function

make = function(x, y)
	return (new ParticleFountain()).init(x, y)
end function
