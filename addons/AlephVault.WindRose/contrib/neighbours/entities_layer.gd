extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer subclass ensures the neighbours
## entities rule is created for it. This rule teleports
## objects walking toward the linked boundaries of this
## map to the opposite respective boundary in another
## map (the respectively linked map).
## 
## See AlephVault__WindRose.Contrib.Neighbours.EntitiesRule
## for more details.

const _Self = preload("./entities_layer.gd")

## The up-linked layer.
@export
var _up_linked: _Self

## The down-linked layer.
@export
var _down_linked: _Self

## The left-linked layer.
@export
var _left_linked: _Self

## The right-linked layer.
@export
var _right_linked: _Self

func _create_rule() -> _EntitiesRule:
	# TODO implement.
	return AlephVault__WindRose.Contrib.Neighbours.EntitiesRule.new(
		self,
		_up_linked.entities_rule,
		_down_linked.entities_rule,
		_left_linked.entities_rule,
		_right_linked.entities_rule
	)
