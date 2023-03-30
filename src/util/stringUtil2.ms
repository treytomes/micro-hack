string.format = function(text, values=null)
	if values isa map then
		for kv in values
			text = text.replace("${" + kv.key + "}", kv.value)
		end for
	else if values isa list then
		if values.len > 0 then
			for n in range(0, values.len - 1)
				text = text.replace("${" + n + "}", values[n])
			end for
		end if
	else if values != null then
		text += values
	end if
	return text
end function

if locals == globals then
	person = {}
	person.firstName = "Trey"
	person.lastName = "Tomes"

	print string.format("Good morning ${firstName} ${lastName}, how are you?", person)
	print string.format("If you want ${0}, you will need to ${1} it.", [ "breakfast", "cook" ])
end if
