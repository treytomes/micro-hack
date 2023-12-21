MessageWindow = {}

MessageWindow.make = function(message, title)
	wnd = (new MessageWindow)
	wnd.bounds = rect.make(4, 4, constants.UI_DISPLAY_WIDTH - 4 * 2, constants.UI_DISPLAY_HEIGHT - 4 * 2)
	wnd.title = title
	wnd.message = message
	return wnd
end function

MessageWindow.draw = function()
	ui.drawWindow(Display.hud, self.bounds, self.title)
	lineCount = ui.drawText(Display.hud, self.message, self.messageBounds)
end function

// Returns the index of the selected item.
MessageWindow.show = function()
	self.draw

	result = null
	while true
		delta = 0
		k = key.get.code
		if keybindings.exit.contains(k) then
			break
		else if keybindings.select.contains(k) then
			break
		end if
	end while
end function

MessageWindow.messageBounds = function()
	return rect.make(self.bounds.left + 2, self.bounds.top + 2, self.bounds.width - 4, self.bounds.height - 4)
end function

return MessageWindow
