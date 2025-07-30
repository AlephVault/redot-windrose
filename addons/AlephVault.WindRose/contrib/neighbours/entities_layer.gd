extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer subclass ensures the neighbours
## entities rule is created for it. This rule teleports
## objects walking toward the linked boundaries of this
## map to the opposite respective boundary in another
## map (the respectively linked map).
## 
## See AlephVault__WindRose.Contrib.Neighbours.EntitiesRule
## for more details.

## The up-linked layer.
@export
var _up_linked: Node2D

## The down-linked layer.
@export
var _down_linked: Node2D

## The left-linked layer.
@export
var _left_linked: Node2D

## The right-linked layer.
@export
var _right_linked: Node2D

func _create_rule() -> _EntitiesRule:
	return AlephVault__WindRose.Contrib.Neighbours.EntitiesRule.new(
		self,
		func(): return _up_linked.rule if _up_linked != null and _up_linked is AlephVault__WindRose.Contrib.Neighbours.EntitiesLayer else null,
		func(): return _down_linked.rule if _down_linked != null and _down_linked is AlephVault__WindRose.Contrib.Neighbours.EntitiesLayer else null,
		func(): return _left_linked.rule if _left_linked != null and _left_linked is AlephVault__WindRose.Contrib.Neighbours.EntitiesLayer else null,
		func(): return _right_linked.rule if _right_linked != null and _right_linked is AlephVault__WindRose.Contrib.Neighbours.EntitiesLayer else null
	)
