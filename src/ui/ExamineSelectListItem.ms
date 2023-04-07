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
	parent.display.backColor = bg
	parent.display.color = fg

	x = parent.listBounds.left
	y = parent.getItemRow(self.index)
	
	self.entity.tile.draw(parent.display, x, y)

	parent.display.row = y
	parent.display.column = x + 2
	parent.display.print(self.entity.str())

	for x in range(parent.listBounds.left, parent.listBounds.right)
		parent.display.setCellBackColor(x, y, bg)
	end for
end function

ExamineSelectListItem.describe = function(parent, bounds=null)
	bounds = math.coalesce(bounds, parent.detailBounds)
	
	ui.clearRect(parent.display, bounds, " ", Color.clear.str(), Color.black.str())

	lineCount = ui.drawText(parent.display, self.entity.description, bounds)
	bounds.height -= lineCount + 1

	self.entity.describe(parent.display, bounds)
end function

return ExamineSelectListItem
