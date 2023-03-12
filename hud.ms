MessageLog = {}
MessageLog.maxSize = 5

MessageLog.make = function()
	log = new MessageLog
	self.messages = []
	log.report("Welcome to the dungeon!")
	return log
end function

MessageLog.clear = function()
	self.messages = []
end function

MessageLog.draw = function(inverse)
	if self.messages.len == 0 then
		return
	end if

	hudText.color = color.white
	hudText.backColor = color.black
	for n in range(0, self.messages.len - 1)
		if inverse then
			hudText.row = n
		else
			hudText.row = 25 - n
		end if
		hudText.column = 0
		hudText.print(self.messages[n])
	end for
end function

MessageLog.report = function(msg)
	self.messages.insert(0, msg)
	while self.messages.len > self.maxSize
		self.messages.pop()
	end while
end function
