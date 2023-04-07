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
	self.selectList.init(Display.hud, rect.make(4, 4, SCREEN_MAX_X - 4 * 2, SCREEN_MAX_Y - 4 * 2))
	self.selectList.reset(list)
end function

ExamineWindow.draw = function()
	if self.selectList.list.len > 1 then
		windowBounds = self.selectList.windowBounds
		ui.drawWindow(Display.hud, windowBounds, "Examine")
		ui.drawVerticalLine(Display.hud, windowBounds.centerX, windowBounds.top + 1, windowBounds.bottom - 1, ui.WINDOW_BORDER_FOREGROUND, ui.WINDOW_BORDER_BACKGROUND, "|")
		
		Display.hud.color = ui.WINDOW_BORDER_FOREGROUND
		Display.hud.row = windowBounds.top
		Display.hud.column = windowBounds.centerX
		Display.hud.print("+")
		
		Display.hud.backColor = color.black
		Display.hud.color = color.white
		Display.hud.row = windowBounds.bottom - 1
		Display.hud.column = windowBounds.left + 1
		Display.hud.print("Examine")

		self.selectList.drawItems()
	else
		windowBounds = self.selectList.detailBounds
		detailBounds = windowBounds.copy()

		windowBounds.width += 2
		windowBounds.height += 2
		windowBounds.x = floor((SCREEN_MAX_X - windowBounds.width) / 2)
		windowBounds.y = floor((SCREEN_MAX_Y - windowBounds.height) / 2)

		detailBounds.x = windowBounds.x + 1
		detailBounds.y = windowBounds.y + 1

		ui.drawWindow(Display.hud, windowBounds, "Examine: {0}".fill([ self.selectList.list[0].entity.name ]))

		self.selectList.selectedItem.describe(self.selectList, detailBounds)
	end if
end function

// Returns the index of the selected item.
ExamineWindow.examine = function(entities)
	self.reset(entities)
	self.draw()

	result = null
	while true
		delta = 0
		k = key.get.code
		if self.selectList.list.len > 1 then
			if keybindings.up.contains(k) then
				delta = -1
			else if keybindings.down.contains(k) then
				delta = 1
			end if
		end if

		if keybindings.exit.contains(k) then
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
