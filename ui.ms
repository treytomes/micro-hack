DEFAULT_TEXT = " "
DEFAULT_FOREGROUND_COLOR = color.gray
DEFAULT_BACKGROUND_COLOR = color.black

coalesce = function(value, defaultValue)
	if value == null then
		return defaultValue
	end if
	return value
end function

drawCell = function(display, x, y, fg, bg, text)
	display.setCell(x, y, text)
	display.setCellColor(x, y, fg)
	display.setCellBackColor(x, y, bg)
end function

clearRect = function(display, bounds, text = null, foregroundColor = null, backgroundColor = null)
	text = coalesce(text, DEFAULT_TEXT)
	foregroundColor = coalesce(foregroundColor, DEFAULT_FOREGROUND_COLOR)
	backgroundColor = coalesce(backgroundColor, DEFAULT_BACKGROUND_COLOR)
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
	centerX = floor((x1 + x2) / 2)
	display.row = y
	display.column = centerX - floor(text.len / 2)
	display.color = fg
	display.backColor = bg
	display.print(text)
end function

WINDOW_BORDER_FOREGROUND = color.blue
WINDOW_BORDER_BACKGROUND = color.black
WINDOW_TITLE_FOREGROUND = color.yellow
WINDOW_TITLE_BACKGROUND = color.black

drawWindow = function(display, bounds, title)
	ui.clearRect(Display.hud, bounds)

	drawVerticalLine(display, bounds.left, bounds.top + 1, bounds.bottom - 1, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "|")
	drawVerticalLine(display, bounds.right, bounds.top + 1, bounds.bottom - 1, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "|")
	drawHorizontalLine(display, bounds.left + 1, bounds.right - 1, bounds.top, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "-")
	drawHorizontalLine(display, bounds.left + 1, bounds.right - 1, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "-")

	drawCell(display, bounds.left, bounds.top, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "+")
	drawCell(display, bounds.right, bounds.top, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "+")
	drawCell(display, bounds.left, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "+")
	drawCell(display, bounds.right, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "+")

	title = " " + title + " "
	halfLength = floor(title.len / 2)
	drawCell(display, bounds.centerX - halfLength - 2, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "]")
	drawCell(display, bounds.centerX - halfLength + title.len - 1, bounds.bottom, WINDOW_BORDER_FOREGROUND, WINDOW_BORDER_BACKGROUND, "[")

	drawCenteredText(display, bounds.left, bounds.right, bounds.bottom, WINDOW_TITLE_FOREGROUND, WINDOW_TITLE_BACKGROUND, title)
end function
