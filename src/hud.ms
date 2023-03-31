Message = {}

Message.make = function(text, foregroundColor = null, backgroundColor = null)
	m = new Message()
	self.maxLifeSpan = 5
	m.lifeSpan = 5
	m.text = text
	m.foregroundColor = math.coalesce(foregroundColor, color.white)
	m.backgroundColor = math.coalesce(backgroundColor, color.black)
	return m
end function

Message.draw = function(hudDisplay, row)
	hudDisplay.row = row
	hudDisplay.column = 0
	ratio = self.lifeSpan / self.maxLifeSpan
	hudDisplay.color = color.lerp(color.clear, self.foregroundColor, ratio)
	hudDisplay.backColor = color.lerp(color.clear, self.backgroundColor, ratio)
	hudDisplay.print(self.text)
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
end function

MessageLog.draw = function(hudDisplay, inverse)
	if self.messages.len == 0 then
		return
	end if
	
	for n in range(0, self.messages.len - 1)
		row = n
		if not inverse then
			row = 25 - n
		end if

		self.messages[n].draw(hudDisplay, row)
	end for
end function

MessageLog.report = function(msg, foregroundColor = null, backgroundColor = null)
	self.messages.insert(0, Message.make(msg, foregroundColor, backgroundColor))
end function

