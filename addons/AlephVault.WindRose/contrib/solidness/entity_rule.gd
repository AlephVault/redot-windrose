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
	optimistic: bool = false
):
	super._init(size, root)
	self.obeys_solidness = obeys_solidness
	_solidness = solidness
	_optimistic = optimistic
