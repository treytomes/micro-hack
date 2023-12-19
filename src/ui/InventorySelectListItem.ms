SelectListItem = require("SelectListItem")

InventorySelectListItem = new SelectListItem

InventorySelectListItem.init = function(entity, inventoryIndex)
	super.init()
	self.index = inventoryIndex
	self.entity = entity
	return self
end function

InventorySelectListItem.draw = function(parent, isSelected)
	stack = self.entity.inventory.get(self.index)
	item = stack.item

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
	parent.display.setCell x, y, item.tile.char, item.tile.foregroundColor, item.tile.backgroundColor

	// parent.display.row = y
	// parent.display.column = x + 2
	// parent.display.print(stack.str())
	parent.display.print stack.str(), x + 2, y, fg, bg
	if self.entity.isEquipped(item) then
		// parent.display.print(" [E]")
		parent.display.print " [E]", x + 2 + stack.str().len, y, fg, bg
	end if

	for x in range(parent.listBounds.left, parent.listBounds.right)
		parent.display.setCellBackColor x, y, bg
	end for
end function

InventorySelectListItem.describe = function(parent)
	stack = self.entity.inventory.get(self.index)
	item = stack.item
	bounds = parent.detailBounds
	
	ui.clearRect(parent.display, bounds, " ", Color.clear.str(), Color.black.str())

	lineCount = ui.drawText(parent.display, item.description, bounds)

	bounds.height -= lineCount + 1
	ui.drawText(parent.display, "GP:" + item.goldValue, bounds, Color.orange.str())
	bounds.height -= 1
	ui.drawText(parent.display, "Weight:" + item.weight, bounds, Color.orange.str())
	bounds.height -= 1
	ui.drawText(parent.display, item.effectStr(), bounds, Color.orange.str())

	bounds.height -= 1
	if self.entity.isEquipped(item) then
		ui.drawText(parent.display, "Equipped.", bounds, Color.green.str())
	//else
	//	ui.drawText(parent.display, "Not equipped.", bounds, Color.yellow.str())
	end if
end function

return InventorySelectListItem
