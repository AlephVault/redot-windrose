extends AlephVault__WindRose.Maps.MapEntity
## This map entity makes use of a Simple rule,
## which is a combination of Blocking, Solidness,
## Navigability and Neighbours rules. Thus, this
## class has the same properties of the other map
## entity subclasses: blocking, solidness, neighbours,
## and navigability-related properties.

const _Solidness = AlephVault__WindRose.Contrib.Solidness.EntityRule.Solidness

@export_category("Solidness")

## Tells whether this object follows the
## solidness rules (i.e. gets blocked by
## other solid objects) or not.
@export
var _obeys_solidness: bool = true

## The solidness for this object.
@export
var _solidness: _Solidness = _Solidness.SOLID

## Tells whether the movement allocation
## is optimistic.
@export
var _optimistic: bool = false

## The solidness mask. Useful only for irregular solidness
## configuration (solidness=IRREGULAR). It should be made
## from letters G (Ghost), S (Solid) or H (Hole), an the
## amount of lines equal to the object's height, and each
## line with a size equal to the object's width. On mismatch,
## everything will be padded with G (ghost) cells.
@export_multiline
var _mask: String = ""

@export_category("Navigability")

## The navigability for this entity. It must be
## a number between 0 and 63, being 0 the default
## value (typically meaning: walking).
@export
var _navigability: int = 0

func _create_rule() -> _EntityRule:
	return AlephVault__WindRose.Contrib.Simple.EntityRule.new(
		self,
		_obeys_solidness,
		_solidness,
		_mask,
		_optimistic,
		_navigability, 
		true
	)
