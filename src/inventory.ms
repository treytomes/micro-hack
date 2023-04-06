// An inventory is a collection of ItemStacks.

Inventory = {}
Inventory.stacks = null

Inventory.init = function()
	self.stacks = []
	return self
end function

Inventory.len = function()
	return self.stacks.len
end function

Inventory.get = function(index)
	return self.stacks[index]
end function

Inventory.contains = function(item)
	for stack in self.stacks
		if stack.item.equals(item) then
			return true
		end if
	end for
	return false
end function

Inventory.find = function(item)
	if self.stacks.len == 0 then
		return null
	end if
	for n in range(0, self.stacks.len - 1)
		if self.stacks[n].item.equals(item) then
			return self.stacks[n]
		end if
	end for
	return null
end function

// Add an item to the inventory.
// This will locate the best stack to add it to, or create a new one.
Inventory.addItem = function(item)
	stack = self.find(item)
	if stack != null and stack.canAddItem(1) then
		stack.addItem(1)
	else
		self.stacks.push((new itemStack.ItemStack).init(item, 1))
	end if
end function

// Remove an item from the stack at the given index.
// Stack will be deleted if it's empty.
Inventory.removeItem = function(index = -1)
	stack = self.stacks[index]
	if stack.canRemoveItem(1) then
		stack.removeItem(1)
		self.cleanup()
		return
	end if
end function

Inventory.use = function(entity, index)
	stack = self.stacks[index]
	stack.use(entity)
	if stack.count == 0 then
		self.cleanup()
	end if
end function

// Clear out any empty stacks.
Inventory.cleanup = function()
	n = 0
	while n < self.stacks.len
		if self.stacks[n].count == 0 then
			self.stacks.remove(n)
		else
			n += 1
		end if
	end while
end function
