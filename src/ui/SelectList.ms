SelectList = {}
SelectList.ITEM_BACKGROUND = Color.black
SelectList.ITEM_BACKGROUND_SELECTED = Color.gray
SelectList.ITEM_FOREGROUND = Color.gray
SelectList.ITEM_FOREGROUND_SELECTED = Color.black
SelectList.LIST_MORE_FOREGROUND = Color.silver
SelectList.LIST_NOMORE_FOREGROUND = Color.silver.darker
SelectList.display = null
SelectList.windowBounds = null
SelectList.firstDisplayIndex = 0
SelectList.selectedInventoryIndex = 0
SelectList.windowBounds = null
SelectList.list = null

SelectList.init = function(display, bounds)
	self.display = display
	self.windowBounds = bounds
	self.list = []
	return self
end function

SelectList.reset = function(list)
	self.firstDisplayIndex = 0
	self.selectedInventoryIndex = 0
	self.list = list
end function

SelectList.listBounds = function()
	return rect.make(self.windowBounds.left + 1, self.windowBounds.top + 1, self.windowBounds.width / 2 - 1, self.windowBounds.height - 2)
end function

SelectList.detailBounds = function()
	return rect.make(self.windowBounds.centerX + 1, self.windowBounds.top + 2, self.windowBounds.width / 2 - 2, self.windowBounds.height - 3)
end function

SelectList.maxDisplayLines = function()
	return self.windowBounds.height - 2 - 2
end function

SelectList.lastDisplayIndex = function()
	return self.firstDisplayIndex + self.maxDisplayLines - 1
end function

SelectList.isAtTop = function()
	return self.firstDisplayIndex == 0
end function

SelectList.isAtBottom = function()
	return self.lastDisplayIndex >= self.list.len - 1
end function

SelectList.scrollUp = function()
	if not self.isAtTop then
		self.firstDisplayIndex -= 1
		self.drawItems()
	end if
end function

SelectList.scrollDown = function()
	if not self.isAtBottom then
		self.firstDisplayIndex += 1
		self.drawItems()
	end if
end function

SelectList.erase = function()
	ui.clearRect(self.display, self.windowBounds, " ", Color.clear, Color.clear)
end function

SelectList.getItemRow = function(itemIndex)
	return self.listBounds.bottom - 1 - itemIndex + self.firstDisplayIndex
end function

SelectList.drawItem = function(index, isSelected)
	self.list[index].draw(self, isSelected)
end function

SelectList.selectedItem = function()
	if self.list.len == 0 then return null
	return self.list[self.selectedInventoryIndex]
end function

SelectList.selectInUI = function(newIndex)
	self.drawItem(self.selectedInventoryIndex, false)
	self.selectedInventoryIndex = newIndex
	self.drawItem(self.selectedInventoryIndex, true)

	self.selectedItem.describe(self)
end function

SelectList.drawItems = function()
	ui.clearRect(self.display, self.listBounds, " ", Color.clear.str(), Color.black.str())

	n = 1
	x = self.windowBounds.left + 1
	y = self.windowBounds.bottom - 1
	bg = Color.black

	if not self.isAtTop then
		fg = self.LIST_MORE_FOREGROUND
		self.display.print("^" * (self.windowBounds.width / 2 - 1), x, y, fg, bg)
	else
		fg = self.LIST_NOMORE_FOREGROUND
		self.display.print("^" * (self.windowBounds.width / 2 - 1), x, y, fg, bg)
	end if
	y -= 1

	if self.list.len == 0 then
		self.display.print("You've got nothing.", self.windowBounds.left + 1, y, fg, bg)
	else
		for n in range(self.firstDisplayIndex, self.lastDisplayIndex)
			if math.isInRange(n, 0, self.list.len - 1) then
				self.list[n].draw(self, self.selectedInventoryIndex == n)
			end if
			y -= 1
			n += 1
		end for
	end if

	if not self.isAtBottom then
		self.display.color = self.LIST_MORE_FOREGROUND.str()
	else
		self.display.color = self.LIST_NOMORE_FOREGROUND.str()
	end if
	x = self.windowBounds.left + 1
	y = self.windowBounds.top + 1
	bg = self.ITEM_BACKGROUND
	self.display.print("v" * (self.windowBounds.width / 2 - 1), x, y, fg, bg)

	if self.selectedItem != null then self.selectedItem.describe(self)
end function

return SelectList