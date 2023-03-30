makeDeathParticles = function(pnt)
	p = particleFountain.make(pnt.x, pnt.y)
	p.spawnRate = 0

	SPEED = 50
	LIFESPAN = 800
	FG_COLOR = Color.red
	BG_COLOR = Color.black

	p.particles.push(particle.make("*", p.x, p.y,  1,  1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(particle.make("*", p.x, p.y,  0,  1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(particle.make("*", p.x, p.y, -1,  1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(particle.make("*", p.x, p.y,  1,  0, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(particle.make("*", p.x, p.y, -1,  0, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(particle.make("*", p.x, p.y,  1, -1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(particle.make("*", p.x, p.y,  0, -1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))
	p.particles.push(particle.make("*", p.x, p.y, -1, -1, SPEED, LIFESPAN, FG_COLOR, BG_COLOR))

	return p
end function

makeLevelUpParticles = function(pnt)
	p = particleFountain.make(pnt.x, pnt.y)
	p.lifeSpan = 1000
	p.spawnRate = 5
	p.onSpawn = function()
		speed = 50
		lifespan = 800
		bg = Color.black
		dx = math.random(-2, 2) / 2
		dy = math.random(-2, 2) / 2
		fg = Color.random
		return particle.make("*", self.x, self.y, dx, dy, speed, lifespan, Color.random, bg)
	end function

	//speed = 50
	//lifespan = 800
	//bg = Color.black
	//for n in range(0, 50)
	//	dx = math.random(-1, 1)
	//	dy = math.random(-1, 1)
	//	fg = Color.random
	//	return particle.make("*", p.x, p.y, dx, dx, speed, lifespan, Color.random, bg)
	//	p.particles.push(spawnLevelUpParticle(p))
	//end for

	//p.particles.push(particle.make("*", p.x, p.y,  1,  1, speed, lifespan, Color.random, bg))
	//p.particles.push(particle.make("*", p.x, p.y,  0,  1, speed, lifespan, Color.random, bg))
	//p.particles.push(particle.make("*", p.x, p.y, -1,  1, speed, lifespan, Color.random, bg))
	//p.particles.push(particle.make("*", p.x, p.y,  1,  0, speed, lifespan, Color.random, bg))
	//p.particles.push(particle.make("*", p.x, p.y, -1,  0, speed, lifespan, Color.random, bg))
	//p.particles.push(particle.make("*", p.x, p.y,  1, -1, speed, lifespan, Color.random, bg))
	//p.particles.push(particle.make("*", p.x, p.y,  0, -1, speed, lifespan, Color.random, bg))
	//p.particles.push(particle.make("*", p.x, p.y, -1, -1, speed, lifespan, Color.random, bg))

	return p
end function

makeMessageParticles = function(pnt, message, foregroundColor)
	message = str(message)
	pnt = point.make(pnt.x, pnt.y)
	pnt.x -= floor(message.len / 2)

	p = particleFountain.make(pnt.x, pnt.y)
	p.spawnRate = 0

	SPEED = 50
	LIFESPAN = 800
	FG_COLOR = foregroundColor
	BG_COLOR = Color.black

	p.particles.push(particle.make(message, p.x, p.y, 0, 0.5, SPEED, LIFESPAN, FG_COLOR, BG_COLOR));

	return p
end function
