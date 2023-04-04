Name = {}
Name.first = ""
Name.nick = ""
Name.last = ""

Name.init = function(first, nick, last)
	self.first = first
	self.nick = nick
	self.last = last
	return self
end function

Name.str = function()
	return "{0} ""{1}"" {2}".fill([self.first, self.nick, self.last])
end function

generateName = function(isBoy)
	firstParts = ["Ad", "An", "Ar", "Au", "Av", "Ba", "Be", "Ca", "Co", "Da", "De", "Di", "Do", "Du", "El", "Em", "En", "Er", "Fa", "Fe", "Fi", "Fr", "Ga", "Ge", "Gi", "Go", "Gu", "Ha", "He", "Ho", "Ig", "Im", "In", "Ja", "Je", "Jo", "Ju", "Ka", "Ke"]
	firstParts = ["Al", "Am", "An", "Ar", "Au", "Av", "Be", "Bi", "Ca", "Ce", "Da", "De", "Di", "Do", "Du", "El", "Em", "En", "Er", "Fa", "Fe", "Fi", "Fl", "Ga", "Ge", "Gi", "Ha", "He", "In", "Io", "Is", "Ja", "Je", "Jo", "Ju", "Ka", "Ke"]
    
	if isBoy then
	    secondParts = ["be", "do", "go", "jo", "lo", "mo", "ne", "no", "po", "ro", "ru", "so", "su", "to", "ve", "ze"]
    else
    	secondParts = ["ba", "da", "di", "fi", "ji", "ka", "ki", "la", "li", "ma", "na", "ni", "pa", "pi", "ra", "ri", "sa", "si", "ta", "ti", "va", "vi", "za"]
    end if

    suffixes = ["son", "ton", "ham", "ley", "man", "ford", "wood", "stone", "well", "cott", "ford", "bourne", "ley", "hall", "mond", "rick", "ford", "stead", "ton", "by", "worth", "dale", "wick", "ley", "don", "den", "more", "bank", "cott", "stead", "wick", "cott", "worth", "dale", "field", "shaw", "worth", "den"]

    firstName = math.randomChoice(firstParts) // First syllable.
	secondName = math.randomChoice(secondParts) // Second syllable.

	odds = math.random(0, 2)
	nickName = firstName
	if odds == 0 then
		nickName += secondName
	else if odds == 1 then
		nickName += firstName.lower()
	end if

	if math.random(0, 1) == 0 then
	    secondName += math.randomChoice(secondParts) // Maybe a third syllable.
    end if

	lastName = math.randomChoice(firstParts) + math.randomChoice(suffixes)

    return (new Name).init("{0}{1}".fill([ firstName, secondName]), nickName, lastName)
end function

boy = function()
	return generateName(true)
end function

girl = function()
	return generateName(false)
end function
