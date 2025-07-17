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
	HOLE
}

# The solidness for this object.
var _solidness: Solidness = Solidness.SOLID

## The solidness for this object.
var solidness: Solidness:
	get:
		return _solidness
	set(value):
		var old = _solidness
		_solidness = solidness
		on_property_updated.emit("solidness", old, value)

## Tells whether this object follows the
## solidness rules (i.e. gets blocked by
## other solid objects) or not.
var obeys_solidness: bool = true
