extends AlephVault__WindRose.Maps.MapEntity
## This map entity subclass ensures the solidness
## entity rule is created for it.
##
## If this object has `obeys_solidness` in true, then
## this object
##
## See AlephVault__WindRose.Contrib.Solidness.EntityRule
## for more details.

const _Solidness = AlephVault__WindRose.Contrib.Solidness.EntityRule.Solidness

## Tells whether this object follows the
## solidness rules (i.e. gets blocked by
## other solid objects) or not.
@export_category("Solidness")
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

func _create_rule() -> _EntityRule:
	return AlephVault__WindRose.Contrib.Solidness.EntityRule.new(
		self, _obeys_solidness, _solidness, _mask, _optimistic, true
	)
