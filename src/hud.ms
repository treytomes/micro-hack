Message = {}

Message.make = function(text, foregroundColor = null, backgroundColor = null)
	m = new Message()
	self.maxLifeSpan = 5
	m.lifeSpan = 5
	m.text = text
	m.foregroundColor = math.coalesce(foregroundColor, Color.white)
	m.backgroundColor = math.coalesce(backgroundColor, Color.black)
	return m
end function

Message.draw = function(row)
	ratio = self.lifeSpan / self.maxLifeSpan
	fg = Color.lerp(Color.clear, self.foregroundColor, ratio)
	bg = Color.lerp(Color.clear, self.backgroundColor, ratio)
	Display.hud.print self.text, 0, row, fg, bg
end function

MessageLog = {}

MessageLog.make = function()
	log = new MessageLog
	self.messages = []
	log.report("Welcome to the dungeon!")
	return log
end function

MessageLog.clear = function()
	self.messages = []
end function

MessageLog.update = function()
	if self.messages.len == 0 then
		return
	end if
	
	for n in range(0, self.messages.len - 1)
		m = self.messages[n]
		if m != null then
			m.lifeSpan -= 1
			if m.lifeSpan <= 0 then
				self.messages[n] = null
			end if
		end if
	end for

	n = 0
	while n < self.messages.len
		if self.messages[n] == null then
			self.messages.remove(n)
		else
			n += 1
		end if
	end while
	
	self.draw()
end function

MessageLog.draw = function()
	if self.messages.len == 0 then
		return
	end if
	
	for n in range(0, self.messages.len - 1)
		self.messages[n].draw(n)
	end for
end function

MessageLog.report = function(msg, foregroundColor = null, backgroundColor = null)
	self.messages.insert(0, Message.make(msg, foregroundColor, backgroundColor))
end function

MessageLog.reportNow = function(msg, foregroundColor = null, backgroundColor = null)
	self.report(msg)
	self.update()
end function

