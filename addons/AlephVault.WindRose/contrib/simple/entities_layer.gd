extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer makes use of a Simple rule,
## which is a combination of Blocking, Solidness,
## Navigability and Neighbours rules. Thus, this
## class has the same properties of the other entities
## layer subclasses: blocking, solidness, neighbours,
## and navigability-related properties.
##
## To get more information on the related behaviorus,
## see these classes:
##
## - AlephVault__WindRose.Contrib.Solidness.EntitiesLayer
## - AlephVault__WindRose.Contrib.Blocking.EntitiesLayer
## - AlephVault__WindRose.Contrib.Neighbours.EntitiesLayer
## - AlephVault__WindRose.Contrib.Navigability.EntitiesLayer

@export_category("Neighbours")

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
	return AlephVault__WindRose.Contrib.Simple.EntitiesRule.new(
		self,
		func(): return _up_linked.rule.neighbours_rule if _up_linked != null and _up_linked is AlephVault__WindRose.Contrib.Simple.EntitiesLayer else null,
		func(): return _down_linked.rule.neighbours_rule if _down_linked != null and _down_linked is AlephVault__WindRose.Contrib.Simple.EntitiesLayer else null,
		func(): return _left_linked.rule.neighbours_rule if _left_linked != null and _left_linked is AlephVault__WindRose.Contrib.Simple.EntitiesLayer else null,
		func(): return _right_linked.rule.neighbours_rule if _right_linked != null and _right_linked is AlephVault__WindRose.Contrib.Simple.EntitiesLayer else null
	)
