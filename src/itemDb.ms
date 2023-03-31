// itemsByLevel is a list of item chances by level.
// The index into itemsByLevel is the level.
// Each entry into that level is a list of [ item, rarity ] that can be fed into math.selectItemByChance.

itemsByLevel = []

addItem = function(item)
	while item.level >= itemsByLevel.len
		itemsByLevel.push([])
	end while
	itemsByLevel[item.level].push([ item, item.rarity ])
end function

// This will return an item, or null of the requested level has no items.
getRandomItemForLevel = function(level)
	if level < 0 then level = 0
	if level >= itemsByLevel.len then level = itemsByLevel.len - 1

	if itemsByLevel[level].len == 0 then return null
	return math.selectItemByChance(itemsByLevel[level])
end function
