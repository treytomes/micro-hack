Particle = {}
Particle.make = function(text, x, y, dx, dy, speed, lifeSpan, foregroundColor, backgroundColor)
	p = new Particle
	p.text = text
	p.x = x
	p.y = y
	p.dx = dx
	p.dy = dy
	p.speed = speed
	p.lifeSpan = lifeSpan
	p.foregroundColor = foregroundColor
	p.backgroundColor = backgroundColor

	p.totalTime = 0
	p.lastUpdateTime = 0

	return p
end function

Particle.isAlive = function()
	return self.x >= 0 and self.x < 68 and self.y >= 0 and self.y < 26 and self.totalTime < self.lifeSpan
end function

Particle.isDead = function()
	return not self.isAlive
end function

Particle.update = function(dsp, deltaTime, map)
	self.totalTime += deltaTime
	//text.row = 11
	//text.column = 10
	//print "Time:" + self.totalTime
	if self.isDead then
		self.erase(dsp)
	else if self.totalTime - self.lastUpdateTime > self.speed then
		self.erase(dsp)
		self.x += self.dx
		self.y += self.dy
		self.lastUpdateTime = self.totalTime

		// TODO: Can't decide if particles should be rendered if that section of the map is hidden.
		if self.isAlive then //and map.isVisible(self.x, self.y) then
			self.draw(dsp)
		end if
	end if
end function

Particle.erase = function(dsp)
	dsp.row = self.y
	dsp.column = self.x
	dsp.color = color.clear
	dsp.backColor = color.clear
	dsp.print(self.text)
end function

Particle.draw = function(dsp)
	dsp.row = self.y
	dsp.column = self.x
	dsp.color = self.foregroundColor
	dsp.backColor = self.backgroundColor
	dsp.print(self.text)
end function

ParticleFountain = {}

ParticleFountain.make = function(x, y)
	fountain = new ParticleFountain
	fountain.x = x
	fountain.y = y
	fountain.particles = []

	fountain.spawnTimer = 0
	fountain.lastSpawnTime = 0
	fountain.spawnRate = 1000

	return fountain
end function

ParticleFountain.makeDamageParticles = function(x, y)
	p = self.make(x, y)
	p.spawnRate = 0

	SPEED = 50
	LIFESPAN = 800
	FG_COLOR = color.red
	BG_COLOR = color.black

	p.particles.push(Particle.make("*", p.x, p.y,  1,  1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(Particle.make("*", p.x, p.y,  0,  1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(Particle.make("*", p.x, p.y, -1,  1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(Particle.make("*", p.x, p.y,  1,  0, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(Particle.make("*", p.x, p.y, -1,  0, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(Particle.make("*", p.x, p.y,  1, -1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(Particle.make("*", p.x, p.y,  0, -1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(Particle.make("*", p.x, p.y, -1, -1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))

	return p
end function

ParticleFountain.makeMessageParticles = function(x, y, message, foregroundColor)
	message = str(message)
	x -= floor(message.len / 2)

	p = self.make(x, y)
	p.spawnRate = 0

	SPEED = 50
	LIFESPAN = 800
	FG_COLOR = foregroundColor
	BG_COLOR = color.black

	p.particles.push(Particle.make(message, p.x, p.y, 0, 0.5, SPEED, LIFESPAN, FG_COLOR, BG_COLOR));

	return p
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

ParticleFountain.draw = function(dsp, deltaTime, map)
	self.spawnTimer += deltaTime
	if self.spawnRate > 0 and (self.spawnTimer - self.lastSpawnTime >= self.spawnRate) then
		self.spawn()
		self.lastSpawnTime = self.spawnTimer
	end if

	n = 0
	while n < self.particles.len
		p = self.particles[n]
		p.update(dsp, deltaTime, map)
		if p.isDead then
			p.erase(dsp)
			self.particles.remove(n)
		else
			n += 1
		end if
	end while
end function
