Dice = {}
Dice.numDice = 1
Dice.numSides = 6
Dice.modifier = 0

Dice.make = function(numDice, numSides, modifier = 0)
	d = new Dice
	d.numDice = numDice
	d.numSides = numSides
	d.modifier = modifier
	return d
end function

Dice.zero = function()
	return Dice.make(0, 0)
end function

Dice.roll = function()
	if self.numDice == 0 then
		return 0
	end if

	sum = 0
	for n in range(self.numDice)
		sum += floor(rnd() * self.numSides) + 1
	end for
	return sum + self.modifier
end function

Dice.str = function()
	if features.USE_DICE_NOTATION then
		return self.numDice + "d" + self.numSides + "+" + self.modifier
	else
		return self.min  + "-" + self.max
	end if
end function

Dice.min = function()
	return self.numDice + self.modifier
end function

Dice.max = function()
	return self.numDice * self.numSides + self.modifier
end function

max = function(a, b)
	if a > b then
		return a
	end if
	return b
end function

min = function(a, b)
	if a < b then
		return a
	end if
	return b
end function

isInRange = function(n, min, max)
	return min <= n and n <= max
end function

clamp = function(n, min, max)
	if n < min then return min
	if n > max then return max
	return n
end function

random = function(minValue, maxValue)
	delta = maxValue - minValue + 1
	baseValue = floor(rnd() * delta) + minValue
	return baseValue
end function

selectItemByChance = function(odds)
	value = rnd()
	for row in odds
		item = row[0]
		value -= row[1]
		if value < 0 then
			return row[0]
		end if
	end for
	return odds[odds.len - 1][0]
end function

coalesce = function(value, defaultValue)
	if value == null then
		return defaultValue
	end if
	return value
end function
