extends Object

## Returns true for the whitespace code points that this utility normalizes
## into a regular 0x20 space.
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

## Normalizes a single-line text string.
##
## All recognized whitespace characters are converted to regular 0x20 spaces,
## inner runs of two or more spaces are collapsed to one space, and leading /
## trailing spaces are removed. The returned value may be an empty string.
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

## Normalizes text while preserving line breaks.
##
## Text is split by runs of consecutive "\n" characters. Each non-newline
## substring is normalized with _normalize(), then joined back using the
## original newline runs capped at two consecutive "\n" characters. A final pass
## caps any newline runs that could be produced by empty normalized substrings.
static func _normalize_with_newlines(text: String) -> String:
	var result := ""
	var substring := ""
	var newline_count := 0
	for index in range(text.length()):
		var character := text.substr(index, 1)
		if character == "\n":
			newline_count += 1
			continue
		
		if newline_count > 0:
			result += _normalize(substring)
			result += "\n".repeat(mini(newline_count, 2))
			substring = ""
			newline_count = 0
		
		substring += character
	
	result += _normalize(substring)
	if newline_count > 0:
		result += "\n".repeat(mini(newline_count, 2))
	return _limit_newlines(result)

## Caps all newline runs in text to at most two consecutive "\n" characters.
static func _limit_newlines(text: String) -> String:
	var result := ""
	var newline_count := 0
	for index in range(text.length()):
		var character := text.substr(index, 1)
		if character == "\n":
			newline_count += 1
			if newline_count <= 2:
				result += character
		else:
			newline_count = 0
			result += character
	return result

## Normalizes text for REFMAP preset labels and messages.
##
## When allow_newlines is false, all recognized whitespace, including newlines,
## is treated as regular space and the result is a single line. When
## allow_newlines is true, "\n" runs are preserved as paragraph separators but
## capped at two consecutive newlines, while every substring between newline
## runs is normalized as single-line text. The returned value may be empty.
static func normalize(text: String, allow_newlines: bool = false) -> String:
	if allow_newlines:
		return _normalize_with_newlines(text)
	return _normalize(text)
