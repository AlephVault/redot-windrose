extends AlephVault__WindRose.Core.EntityRule
## This rule allows objects to behave like
## obstacles to other objects, blocking their
## movements.

## The solidness type of this object: positive,
## zero or negative.
enum Solidness {
	## Positive solidness. Blocks movements from
	## other objects obeying this rule.
	SOLID,
	## Zero solidness. Does not block movements
	## from other objects.
	GHOST,
	## Negative solidness. Unblocks one amount
	## of movement block in their squares, thus
	## acting like a 'hole' allowing objects to
	## move as if they were 'exempted'.
	HOLE,
	## Irregular layouts have a "mask" of the
	## width of the underlying object (or it is
	## padded / trimmed accordingly).
	IRREGULAR
}

# The solidness for this object.
var _solidness: Solidness = Solidness.SOLID

# The mask for this object, when using
# irregular solidness.
var _mask: Array[int]

## The solidness for this object. On update, it triggers
## signal: `on_property_updated("solidness", old, value)`.
var solidness: Solidness:
	get:
		return _solidness
	set(value):
		var old = _solidness
		_solidness = value
		on_property_updated.emit("solidness", old, _solidness)

func _fix_mask_line_characters(mask_line: String) -> String:
	var new_line = ""
	for index in range(len(mask_line)):
		var chr = mask_line[index]
		new_line += (chr if chr in "GHS" else "G")
	return new_line

func _fix_mask_line(mask_line: String) -> String:
	var l = len(mask_line)
	# Truncate the string if bigger than width.
	if l > size.x:
		mask_line = mask_line.substr(0, size.x)
	# Replace characters to only use G/H/S, but
	# using G if other characters were used.
	mask_line = _fix_mask_line_characters(mask_line)
	# Pad the string if shorter than width.
	if l < size.x:
		mask_line += "G".repeat(size.x - l)
	return mask_line

func _str_mask_to_int(mask_lines: Array[String]) -> Array[int]:
	var final_mask: Array[int] = []
	final_mask.resize(size.x * size.y)
	for y in range(size.y):
		for x in range(size.x):
			final_mask[y * size.x + x] = "HGS".find(mask_lines[y][x]) - 1
	return final_mask

func _fix_mask(mask: String) -> Array[int]:
	# Convert it to uppercase, split it,
	# and keep only a maximum amount of
	# lines: the height of this object.
	var lines: Array[String] = mask.to_upper().split("\n").slice(0, size.y)
	# For each existing line, fix it.
	for line_index in range(len(lines)):
		lines[line_index] = _fix_mask_line(lines[line_index])
	# Add extra GGG...GGG lines, one for each index
	# until the height is satisfaced.
	for extra_line_index in range(len(lines), size.y):
		lines.append("G".repeat(size.x))
	# Join everything by the end and convert it
	# to an integer mask.
	return _str_mask_to_int(lines)

func _check_int_mask(mask: Array[int]) -> bool:
	var s = size.x * size.y
	if len(mask) != s:
		return false
	for index in range(s):
		if mask[index] < -1 or mask[index] > 1:
			return false
	return true

## The solidness for this object. Useful only on irregular
## solidness in the "solidness" property.. On update, it
## triggers signal: `on_property_updated("solidness.mask",
## old, value)`.
var mask: Array[int]:
	get:
		return _mask
	set(value):
		if _check_int_mask(value):
			var old = _mask
			_mask = value
			on_property_updated.emit("solidness.mask", old, _mask)
		else:
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"invalid_mask", "Invalid mask size or values"
			)

## Tells whether this object follows the
## solidness rules (i.e. gets blocked by
## other solid objects) or not.
var obeys_solidness: bool = true

# Tells whether the movement allocation
# is optimistic.
var _optimistic: bool

var optimistic: bool:
	get:
		return _optimistic
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "optimistic"
		)

func _init(
	size: Vector2i, root: bool = true,
	obeys_solidness: bool = true,
	solidness: Solidness = Solidness.SOLID,
	mask: String = "",
	optimistic: bool = false
):
	super._init(size, root)
	self.obeys_solidness = obeys_solidness
	_solidness = solidness
	_mask = _fix_mask(mask)
	_optimistic = optimistic
