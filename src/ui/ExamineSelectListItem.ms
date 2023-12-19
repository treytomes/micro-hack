SelectListItem = require("SelectListItem")

ExamineSelectListItem = new SelectListItem

ExamineSelectListItem.init = function(entity, index)
	super.init()
	self.entity = entity
	self.index = index
	return self
end function

ExamineSelectListItem.draw = function(parent, isSelected)
	if isSelected then
		bg = parent.ITEM_BACKGROUND_SELECTED.str()
		fg = parent.ITEM_FOREGROUND_SELECTED.str()
	else
		bg = parent.ITEM_BACKGROUND.str()
		fg = parent.ITEM_FOREGROUND.str()
	end if

	x = parent.listBounds.left
	y = parent.getItemRow(self.index)
		
	// The backgroundColor won't actually be visible.  It'll be overwritten in that last for-loop.
	parent.display.setCell x, y, self.entity.tile.char, self.entity.tile.foregroundColor, self.entity.tile.backgroundColor

	parent.display.print self.entity.str(), x + 2, y, fg, bg

	for x in range(parent.listBounds.left, parent.listBounds.right)
		parent.display.setCellBackColor x, y, bg
	end for
end function

ExamineSelectListItem.describe = function(parent)
	bounds = parent.detailBounds
	
	ui.clearRect(parent.display, bounds, " ", Color.clear.str(), Color.black.str())

	lineCount = ui.drawText(parent.display, self.entity.description, bounds)
	bounds.height -= lineCount + 1

	self.entity.describe(parent.display, bounds)
end function

return ExamineSelectListItem
