makeDeathParticles = function(pnt)
	p = particleFountain.make(pnt.x, pnt.y)
	p.spawnRate = 0

	SPEED = 50
	LIFESPAN = 800
	FG_COLOR = color.red
	BG_COLOR = color.black

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

makeMessageParticles = function(pnt, message, foregroundColor)
	message = str(message)
	pnt = point.make(pnt.x, pnt.y)
	pnt.x -= floor(message.len / 2)

	p = particleFountain.make(pnt.x, pnt.y)
	p.spawnRate = 0

	SPEED = 50
	LIFESPAN = 800
	FG_COLOR = foregroundColor
	BG_COLOR = color.black

	p.particles.push(particle.make(message, p.x, p.y, 0, 0.5, SPEED, LIFESPAN, FG_COLOR, BG_COLOR));

	return p
end function
