
rollDice = function(numDice, numSides)
	sum = 0
	for n in range(numDice)
		sum += floor(rnd() * numSides) + 1
	end for
	return sum
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