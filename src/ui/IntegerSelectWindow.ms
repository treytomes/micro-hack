IntegerSelectWindow = {}

IntegerSelectWindow.make = function(min, max, title)
    return (new IntegerSelectWindow).init(min, max, title)
end function

IntegerSelectWindow.init = function(min, max, title)
    self.min = min
    self.max = max
    self.title = title
    self.result = min
    self.fieldSize = math.max(str(self.min).len, str(self.max).len)

    margin = 10
    width = math.max(self.fieldSize + 4, title.len + 6)
    height = 5
    x = (constants.UI_DISPLAY_WIDTH - width) / 2
    y = (constants.UI_DISPLAY_HEIGHT - height) / 2
    self.bounds = rect.make(x, y, width, 5)
    return self
end function

IntegerSelectWindow.drawLabel = function()
    x = self.bounds.left + (self.bounds.width - (self.fieldSize + 4)) / 2
    y = self.bounds.bottom - 2
    text = str(self.result).pad(self.fieldSize)
    Display.hud.setCell x, y, 17, Color.white, Color.black
    Display.hud.print text, x + 2, y, Color.yellow, Color.black
    Display.hud.setCell x + 2 + self.fieldSize + 1, y, 16, Color.white, Color.black
end function

IntegerSelectWindow.draw = function()
    ui.drawWindow(Display.hud, self.bounds, self.title)
    self.drawLabel()
end function

IntegerSelectWindow.select = function()
    self.draw()

    while true
        delta = 0
		k = key.get.code
		if keybindings.up.contains(k) or keybindings.left.contains(k) then
			delta = -1
		else if keybindings.down.contains(k) or keybindings.right.contains(k) then
			delta = 1
		else if keybindings.exit.contains(k) then
			self.result = null
            break
		else if keybindings.select.contains(k) then
			break
		end if

		if delta != 0 then
			self.result = math.clamp(self.result + delta, self.min, self.max)
            self.drawLabel()
        end if

    end while

    ui.clearRect(Display.hud, self.bounds, null, Color.clear, Color.clear)

    return self.result
end function

return IntegerSelectWindow
