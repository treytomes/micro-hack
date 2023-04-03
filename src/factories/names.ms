Name = {}
Name.first = ""
Name.last = ""

Name.init = function(first, last)
	self.first = first
	self.last = last
	return self
end function

Name.str = function()
	return "{0} {1}".fill([self.first, self.last])
end function

generateName = function(isBoy)
    if isBoy then
        firstParts = ["Ad", "An", "Ar", "Au", "Av", "Ba", "Be", "Ca", "Co", "Da", "De", "Di", "Do", "Du", "El", "Em", "En", "Er", "Fa", "Fe", "Fi", "Fr", "Ga", "Ge", "Gi", "Go", "Gu", "Ha", "He", "Ho", "Ig", "Im", "In", "Ja", "Je", "Jo", "Ju", "Ka", "Ke"]
    else
        firstParts = ["Al", "Am", "An", "Ar", "Au", "Av", "Be", "Bi", "Ca", "Ce", "Da", "De", "Di", "Do", "Du", "El", "Em", "En", "Er", "Fa", "Fe", "Fi", "Fl", "Ga", "Ge", "Gi", "Ha", "He", "In", "Io", "Is", "Ja", "Je", "Jo", "Ju", "Ka", "Ke"]
    end if

    secondParts = ["ba", "be", "da", "di", "do", "fi", "go", "ji", "jo", "ka", "ki", "la", "li", "lo", "ma", "mo", "na", "ne", "ni", "no", "pa", "pi", "po", "ra", "ri", "ro", "ru", "sa", "si", "so", "su", "ta", "ti", "to", "va", "ve", "vi", "za", "ze"]
    suffixes = ["son", "ton", "ham", "ley", "man", "ford", "wood", "stone", "well", "cott", "ford", "bourne", "ley", "hall", "mond", "rick", "ford", "stead", "ton", "by", "worth", "dale", "wick", "ley", "don", "den", "more", "bank", "cott", "stead", "wick", "cott", "worth", "dale", "field", "shaw", "worth", "den"]

    firstName = math.randomChoice(firstParts)
    secondName = math.randomChoice(secondParts) + math.randomChoice(secondParts)
    lastName = math.randomChoice(firstParts) + math.randomChoice(suffixes)

    return (new Name).init("{0}{1}".fill([ firstName, secondName]), lastName)
end function

boy = function()
	return generateName(true)
end function

girl = function()
	return generateName(false)
end function
