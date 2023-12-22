MessageWindow = {}

MessageWindow.make = function(message, options, title)
	wnd = (new MessageWindow)
	wnd.bounds = rect.make(4, 4, constants.UI_DISPLAY_WIDTH - 4 * 2, constants.UI_DISPLAY_HEIGHT - 4 * 2)
	wnd.title = title
	wnd.message = message

	wnd.selectedOptionIndex = 0
	if options == null or options.len == 0 then
		wnd.options = [ "OK" ]
	else
		wnd.options = options
	end if

	return wnd
end function

MessageWindow.drawOption = function(optionIndex, isSelected)
	// a=Color.white
	// b=Color.black
	innerBounds = self.messageBounds
	text = self.options[optionIndex]
	yDelta = self.options.len - optionIndex - 2

	// c=Color.blue.light
	Display.hud.print(text, innerBounds.left + 2, innerBounds.top + 1 + yDelta, Color.white, Color.black)

	if isSelected then
		Display.hud.print(">", innerBounds.left, innerBounds.top + 1 + yDelta, Color.blue.light, Color.black)
	end if
end function

MessageWindow.drawOptions = function()
	for n in range(self.options.len - 1)
		isSelected = (self.selectedOptionIndex == n)
		// globals.err=[self.selectedOptionIndex, isSelected, n]
		self.drawOption(n, isSelected)
	end for 
end function

MessageWindow.draw = function()
	ui.drawWindow(Display.hud, self.bounds, self.title)
	lineCount = ui.drawText(Display.hud, self.message, self.messageBounds)

	self.drawOptions()
end function

// Returns the index of the selected item.
MessageWindow.show = function()
	self.draw()

	result = null
	while true
		delta = 0
		k = key.get.code
		if keybindings.up.contains(k) then
			delta = -1
		else if keybindings.down.contains(k) then
			delta = 1
		else if keybindings.exit.contains(k) then
			result = -1
			break
		else if keybindings.select.contains(k) then
			result = self.selectedOptionIndex
			break
		end if

		if delta != 0 then
			self.selectedOptionIndex += delta
			if self.selectedOptionIndex < 0 or self.selectedOptionIndex >= self.options.len then
				self.selectedOptionIndex -= delta
			else
				self.draw()
			end if
		end if
	end while

	return result
end function

MessageWindow.messageBounds = function()
	return rect.make(self.bounds.left + 2, self.bounds.top + 2, self.bounds.width - 4, self.bounds.height - 4)
end function

return MessageWindow
