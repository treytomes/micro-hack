Particle = {}
Particle.init = function(text, x, y, dx, dy, speed, lifeSpan, foregroundColor, backgroundColor)
	self.text = text
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy
	self.speed = speed
	self.lifeSpan = lifeSpan
	self.foregroundColor = foregroundColor
	self.backgroundColor = backgroundColor
	self.lastRenderOffset = null

	self.totalTime = 0
	self.lastUpdateTime = 0

	return self
end function

Particle.isAlive = function()
	return self.totalTime < self.lifeSpan
end function

Particle.isDead = function()
	return not self.isAlive
end function

Particle.update = function(dsp, deltaTime, map, renderOffset)
	self.totalTime += deltaTime
	if self.isAlive and self.totalTime - self.lastUpdateTime > self.speed then
		self.x += self.dx
		self.y += self.dy
		self.lastUpdateTime = self.totalTime
	end if

	if self.isAlive then
		self.draw(dsp, renderOffset)
	end if
end function

Particle.draw = function(dsp, renderOffset)
	x = floor(renderOffset.x + self.x)
	y = floor(renderOffset.y + self.y)

	if 0 <= x and x <= SCREEN_MAX_X and 0 <= y and y <= SCREEN_MAX_Y then
		dsp.setCell x, y, self.text, self.foregroundColor, self.backgroundColor 
	end if
end function

make = function(text, x, y, dx, dy, speed, lifeSpan, foregroundColor, backgroundColor)
	return (new Particle).init(text, x, y, dx, dy, speed, lifeSpan, foregroundColor, backgroundColor)
end function
