
rollDice = function(numDice, numSides)
	sum = 0
	for n in range(numDice)
		sum += floor(rnd() * numSides) + 1
	end for
	return sum
end function
