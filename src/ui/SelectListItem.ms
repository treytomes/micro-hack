SelectListItem = {}

SelectListItem.init = function(index)
	self.index = index
	return self
end function

// parent: SelectList
// isSelected: boolean
SelectListItem.draw = function(parent, isSelected)
end function

SelectListItem.describe = function(parent)
end function

return SelectListItem
