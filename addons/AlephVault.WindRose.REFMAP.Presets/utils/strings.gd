extends Object

static func _is_space(code: int) -> bool:
	return code == 0x20 or \
		(code >= 0x09 and code <= 0x0d) or \
		code == 0x85 or \
		code == 0xa0 or \
		code == 0x1680 or \
		(code >= 0x2000 and code <= 0x200a) or \
		code == 0x2028 or \
		code == 0x2029 or \
		code == 0x202f or \
		code == 0x205f or \
		code == 0x3000

static func _normalize(text: String) -> String:
	var result := ""
	var previous_was_space := true
	for index in range(text.length()):
		var character := text.substr(index, 1)
		if _is_space(text.unicode_at(index)):
			if not previous_was_space:
				result += " "
			previous_was_space = true
		else:
			result += character
			previous_was_space = false
	return result.rstrip(" ")

static func normalize(text: String, allow_newlines: bool = false) -> String:
	# allow_newlines = allow_newlines
	return _normalize(text)
