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
	if self.isDead then
		self.erase(dsp)
	else if self.totalTime - self.lastUpdateTime > self.speed then
		self.erase(dsp)
		self.x += self.dx
		self.y += self.dy
		self.lastUpdateTime = self.totalTime

		if self.isAlive then //and map.isVisible(self.x, self.y) then
			self.draw(dsp, renderOffset)
		end if
	end if
end function

Particle.erase = function(dsp)
	if self.lastRenderOffset == null then
		return
	end if

	dsp.row = floor(self.lastRenderOffset.y + self.y)
	dsp.column = floor(self.lastRenderOffset.x + self.x)
	dsp.color = Color.clear.str()
	dsp.backColor = Color.clear.str()
	dsp.print(self.text)
end function

Particle.draw = function(dsp, renderOffset)
	dsp.row = floor(renderOffset.y + self.y)
	dsp.column = floor(renderOffset.x + self.x)
	dsp.color = self.foregroundColor.str()
	dsp.backColor = self.backgroundColor.str()
	dsp.print(self.text)
	self.lastRenderOffset = renderOffset
end function

make = function(text, x, y, dx, dy, speed, lifeSpan, foregroundColor, backgroundColor)
	return (new Particle).init(text, x, y, dx, dy, speed, lifeSpan, foregroundColor, backgroundColor)
end function
