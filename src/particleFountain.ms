ParticleFountain = {}
ParticleFountain.onSpawn = null
ParticleFountain.lifeSpan = 0

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
	if self.lifeSpan > 0 then
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
	if self.onSpawn != null and self.lifeSpan > 0 then
		self.particles.push(self.onSpawn())
	end if
end function

ParticleFountain.draw = function(dsp, deltaTime, map, renderOffset)
	self.spawnTimer += deltaTime
	self.lifeSpan -= deltaTime
	if self.spawnRate > 0 and (self.spawnTimer - self.lastSpawnTime >= self.spawnRate) then
		self.spawn()
		self.lastSpawnTime = self.spawnTimer
	end if

	n = 0
	while n < self.particles.len
		p = self.particles[n]
		p.update(dsp, deltaTime, map, renderOffset)
		if p.isDead then
			self.particles.remove(n)
		else
			n += 1
		end if
	end while
end function

make = function(x, y)
	return (new ParticleFountain()).init(x, y)
end function
