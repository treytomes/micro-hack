Message = {}

Message.init = function(text, foregroundColor = null, backgroundColor = null, lifeSpan = 5)
	self.maxLifeSpan = lifeSpan
	self.lifeSpan = lifeSpan
	self.text = text
	self.foregroundColor = math.coalesce(foregroundColor, color.white)
	self.backgroundColor = math.coalesce(backgroundColor, color.black)
	return self
end function

Message.draw = function(row)
	Display.hud.row = row
	Display.hud.column = 0
	ratio = self.lifeSpan / self.maxLifeSpan
	Display.hud.color = color.lerp(color.clear, self.foregroundColor, ratio)
	Display.hud.backColor = color.lerp(color.clear, self.backgroundColor, ratio)
	Display.hud.print(self.text)
end function

MessageLog = {}
MessageLog.lifeSpan = 5

MessageLog.make = function()
	log = new MessageLog
	self.messages = []
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
	self.messages.insert(0, (new Message).init(msg, foregroundColor, backgroundColor, self.lifeSpan))
end function

MessageLog.reportNow = function(msg, foregroundColor = null, backgroundColor = null)
	self.report(msg + " " * (SCREEN_MAX_X - msg.len))
	self.update()
end function

