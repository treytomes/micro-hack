DEFAULT_TEXT = " "
DEFAULT_FOREGROUND_COLOR = Color.gray
DEFAULT_BACKGROUND_COLOR = Color.black

drawCell = function(display, x, y, fg, bg, text)
	if fg isa Color then fg = fg.str()
	if bg isa Color then bg = bg.str()

	// display.setCell(x, y, text)
	// display.setCellColor(x, y, fg)
	// display.setCellBackColor(x, y, bg)

	display.setCell x, y, text, fg, bg
end function

clearRect = function(display, bounds, text = null, foregroundColor = null, backgroundColor = null)
	text = math.coalesce(text, DEFAULT_TEXT)
	foregroundColor = math.coalesce(foregroundColor, DEFAULT_FOREGROUND_COLOR)
	backgroundColor = math.coalesce(backgroundColor, DEFAULT_BACKGROUND_COLOR)
	for y in range(bounds.top, bounds.bottom)
		for x in range(bounds.left, bounds.right)
			drawCell(display, x, y, foregroundColor, backgroundColor, text)
		end for
	end for
end function

drawHorizontalLine = function(display, x1, x2, y, fg, bg, text)
	for x in range(x1, x2)
		drawCell(display, x, y, fg, bg, text)
	end for
end function

drawVerticalLine = function(display, x, y1, y2, fg, bg, text)
	for y in range(y1, y2)
		drawCell(display, x, y, fg, bg, text)
	end for
end function

drawCenteredText = function(display, x1, x2, y, fg, bg, text)
	if fg isa Color then fg = fg.str()
	if bg isa Color then bg = bg.str()
	
	centerX = floor((x1 + x2) / 2)
	
	// display.row = y
	// display.column = centerX - floor(text.len / 2)
	// display.color = fg
	// display.backColor = bg
	// display.print(text)

	display.print text, centerX - floor(text.len / 2), y, fg, bg
end function

// Returns the number of lines printed.
drawText = function(display, text, bounds, fg, bg=null)
	color = math.coalesce(fg, DEFAULT_FOREGROUND_COLOR)
	backColor = math.coalesce(bg, DEFAULT_BACKGROUND_COLOR)

	lineCount = 0
	while text
		x = bounds.x
		y = bounds.bottom - lineCount
		
		if text.len <= bounds.width then
			display.print text, x, y, color, backColor
			return lineCount + 1
		end if
		foundCut = false
		for i in range(bounds.width, 0)
			if text[i] == " " then
				display.print text[:i], x, y, color, backColor
				text = text[i + 1:]
				foundCut = true
				break
			end if
		end for
		if not foundCut then
			// Couldn't find a space to cut on so, out of desperation, just cut at width.
			display.print text[:bounds.width], x, y, color, backColor
			text = text[bounds.width:]
		end if
		lineCount += 1
		if lineCount == bounds.height then break
	end while
	return lineCount
end function

WINDOW_BORDER_FOREGROUND = Color.blue
WINDOW_BORDER_BACKGROUND = Color.black
WINDOW_TITLE_FOREGROUND = Color.yellow
WINDOW_TITLE_BACKGROUND = Color.black

drawWindow = function(display, bounds, title=null)
	ui.clearRect(display, bounds)

	drawVerticalLine(display, bounds.left, bounds.top + 1, bounds.bottom - 1, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 186)
	drawVerticalLine(display, bounds.right, bounds.top + 1, bounds.bottom - 1, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 186)
	drawHorizontalLine(display, bounds.left + 1, bounds.right - 1, bounds.top, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 205)
	drawHorizontalLine(display, bounds.left + 1, bounds.right - 1, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 205)

	drawCell(display, bounds.left, bounds.top, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 200)
	drawCell(display, bounds.right, bounds.top, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 188)
	drawCell(display, bounds.left, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 201)
	drawCell(display, bounds.right, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 187)

	if title != null then
		title = " {0} ".fill([ title ])
		halfLength = floor(title.len / 2)
		drawCell(display, bounds.centerX - halfLength - 2, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 181)
		drawCell(display, bounds.centerX - halfLength + title.len - 1, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, 198)

		drawCenteredText(display, bounds.left, bounds.right, bounds.bottom, WINDOW_TITLE_FOREGROUND, WINDOW_TITLE_BACKGROUND, title)
	end if
end function

SelectList = require("SelectList")
SelectListItem = require("SelectListItem")
InventorySelectListItem = require("InventorySelectListItem")
InventorySelectWindow = require("InventorySelectWindow")
ExamineSelectListItem = require("ExamineSelectListItem")
ExamineWindow = require("ExamineWindow")
MessageWindow = require("MessageWindow")
HeadsUpDisplay = require("HeadsUpDisplay")
IntegerSelectWindow = require("IntegerSelectWindow")

selectItem = function(entity, title)
	return (new ui.InventorySelectWindow).selectItem(entity, title)
end function

examine = function(entities)
	return (new ui.ExamineWindow).examine(entities)
end function

showMessage = function(message, options, title="Message")
	return ui.MessageWindow.make(message, options, title).show()
end function

selectInteger = function(min, max, title="How many?")
	wnd = ui.IntegerSelectWindow.make(min, max, title)
	return wnd.select()
end function
