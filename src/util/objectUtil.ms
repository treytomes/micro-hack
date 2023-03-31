IdFactory = {}
IdFactory.unusedIds = []
IdFactory.nextId = 0

IdFactory.allocate = function()
	if self.unusedIds.len > 0 then
		return self.unusedIds.pop()
	else
		id = self.nextId
		self.nextId += 1
		return id
	end if
end function

IdFactory.free = function(id)
	self.unusedIds.push(id)
end function

Object = {}
Object.id = null

Object.init = function()
	self.id = IdFactory.allocate()
	return self
end function

Object.free = function()
	IdFactory.free(self.id)
	self.id = null
	return self
end function

Object.str = function()
	return "(id:{0})".fill([ id ])
end function

Object.equals = function(other)
	return other != null and self.id == other.id
end function

globals.Object = Object
