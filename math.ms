
rollDice = function(numDice, numSides, modifier = 0)
	sum = 0
	for n in range(numDice)
		sum += floor(rnd() * numSides) + 1
	end for
	return sum + modifier
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

random = function(minValue, maxValue)
	delta = maxValue - minValue + 1
	baseValue = floor(rnd() * delta) + minValue
	return baseValue
end function
