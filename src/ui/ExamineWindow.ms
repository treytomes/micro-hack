SelectList = require("SelectList")

ExamineWindow = {}
ExamineWindow.selectList = new SelectList()

ExamineWindow.generateList = function(entities)
	list = []
	if entities.len > 0 then
		for n in range(0, entities.len - 1)
			list.push((new ui.ExamineSelectListItem).init(entities[n], n))
		end for
	end if
	return list
end function

ExamineWindow.reset = function(entities)
	list = self.generateList(entities)
	self.selectList.init(Display.hud, rect.make(4, 4, 68 - 4 * 2, 26 - 4 * 2))
	self.selectList.reset(list)
end function

ExamineWindow.draw = function(title, description="")
	windowBounds = self.selectList.windowBounds
	ui.drawWindow(Display.hud, windowBounds, title)
	ui.drawVerticalLine(Display.hud, windowBounds.centerX, windowBounds.top + 1, windowBounds.bottom - 1, ui.WINDOW_BORDER_FOREGROUND, ui.WINDOW_BORDER_BACKGROUND, "|")
	
	Display.hud.color = ui.WINDOW_BORDER_FOREGROUND
	Display.hud.row = windowBounds.top
	Display.hud.column = windowBounds.centerX
	Display.hud.print("+")
	
	Display.hud.backColor = color.black
	Display.hud.color = color.white
	Display.hud.row = windowBounds.bottom - 1
	Display.hud.column = windowBounds.left + 1
	Display.hud.print(description)

	self.selectList.drawItems()
end function

// Returns the index of the selected item.
ExamineWindow.examine = function(entities)
	self.reset(entities)
	self.draw("Examine")

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
			newIndex = math.clamp(self.selectList.selectedInventoryIndex + delta, 0, entities.len - 1)

			if newIndex < self.selectList.firstDisplayIndex then
				self.selectList.selectedInventoryIndex = newIndex
				self.selectList.scrollUp()
			else if newIndex > self.selectList.lastDisplayIndex then
				self.selectList.selectedInventoryIndex = newIndex
				self.selectList.scrollDown()
			else
				if math.isInRange(newIndex, 0, entities.len - 1) then
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

return ExamineWindow
