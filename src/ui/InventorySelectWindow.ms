SelectList = require("SelectList")

InventorySelectWindow = {}
InventorySelectWindow.selectList = new SelectList()

InventorySelectWindow.generateList = function(entity)
	list = []
	if entity.inventory.len > 0 then
		for n in range(0, entity.inventory.len - 1)
			list.push((new ui.InventorySelectListItem).init(entity, n))
		end for
	end if
	return list
end function

InventorySelectWindow.reset = function(entity)
	list = self.generateList(entity)
	self.selectList.init(Display.hud, rect.make(4, 4, constants.UI_DISPLAY_WIDTH - 4 * 2, constants.UI_DISPLAY_HEIGHT - 4 * 2))
	self.selectList.reset(list)
end function

InventorySelectWindow.draw = function(title) //, description="")
	windowBounds = self.selectList.windowBounds
	ui.drawWindow(Display.hud, windowBounds, title)
	ui.drawVerticalLine(Display.hud, windowBounds.centerX, windowBounds.top + 1, windowBounds.bottom - 1, ui.WINDOW_BORDER_FOREGROUND, ui.WINDOW_BORDER_BACKGROUND, 179)
	ui.drawCell(Display.hud, windowBounds.centerX, windowBounds.top, ui.WINDOW_BORDER_FOREGROUND, ui.WINDOW_BORDER_BACKGROUND, 207)
	
	// I'm not actually using the description anywhere.
	// Display.hud.print description, windowBounds.left + 1, windowBounds.bottom - 1, color.white, color.black

	self.selectList.drawItems()
end function

// Returns the index of the selected item.
InventorySelectWindow.selectItem = function(entity, windowName)
	self.reset(entity)
	self.draw(windowName)

	result = null
	while true
		delta = 0
		k = key.get.code
		if keybindings.up.contains(k) then
			delta = -1
		else if keybindings.down.contains(k) then
			delta = 1
		else if keybindings.exit.contains(k) then
			break
		else if keybindings.select.contains(k) then
			result = self.selectList.selectedInventoryIndex
			break
		end if

		if delta != 0 then
			newIndex = math.clamp(self.selectList.selectedInventoryIndex + delta, 0, entity.inventory.len - 1)

			if newIndex < self.selectList.firstDisplayIndex then
				self.selectList.selectedInventoryIndex = newIndex
				self.selectList.scrollUp()
			else if newIndex > self.selectList.lastDisplayIndex then
				self.selectList.selectedInventoryIndex = newIndex
				self.selectList.scrollDown()
			else
				if math.isInRange(newIndex, 0, entity.inventory.len - 1) then
					self.selectList.selectInUI(newIndex)
				end if
			end if
		end if
	end while

	self.selectList.erase()
	if self.selectList.selectedItem == null then
		return null
	else
		return result
	end if
end function

return InventorySelectWindow
