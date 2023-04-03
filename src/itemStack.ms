ItemStack = {}

ItemStack.item = null
ItemStack.count = 0
ItemStack.maxCount = 99

ItemStack.init = function(item, count=1, maxCount=99)
	self.item = item
	self.count = count
	self.maxCount = maxCount
	return self
end function

ItemStack.str = function()
	if self.count == 1 then
		return self.item.str()
	else
		return "{0} x{1}".fill([self.item.str(), self.count])
	end if
end function

ItemStack.canAddItem = function(count=1)
	return self.count + count <= self.maxCount
end function

ItemStack.canRemoveItem = function(count=1)
	return self.count - count >= 0
end function

ItemStack.addItem = function(count=1)
	self.count += count
end function

ItemStack.removeItem = function(count=1)
	self.count -= count
end function

ItemStack.use = function(entity)
	self.item.use(entity)
	if self.item.isConsumedOnUse then
		self.count -= 1
	end if
end function
