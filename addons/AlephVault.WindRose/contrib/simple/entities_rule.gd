extends AlephVault__WindRose.Core.EntitiesRule
## This entities rule combines the power of the
## blocking, solidness, navigability and neighbours
## entities rules. The logic to allow a movement
## requires approval from all the 4 behaviours, and
## the callbacks of this rule are forwarded to the
## 4 behaviours as well.
##
## To get more information on the related behaviorus,
## see these classes:
##
## - AlephVault__WindRose.Contrib.Solidness.EntitiesRule
## - AlephVault__WindRose.Contrib.Blocking.EntitiesRule
## - AlephVault__WindRose.Contrib.Neighbours.EntitiesRule
## - AlephVault__WindRose.Contrib.Navigability.EntitiesRule

# The underlying blocking entities rule.
var _blocking_rule: AlephVault__WindRose.Contrib.Blocking.EntitiesRule

# The underlying solidness entities rule.
var _solidness_rule: AlephVault__WindRose.Contrib.Solidness.EntitiesRule

# The underlying neighbours entities rule.
var _neighbours_rule: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule

# The underlying navigability entities rule.
var _navigability_rule: AlephVault__WindRose.Contrib.Navigability.EntitiesRule

## The underlying blocking entities rule.
var blocking_rule: AlephVault__WindRose.Contrib.Blocking.EntitiesRule:
	get:
		return _blocking_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "blocking_rule"
		)

## The underlying solidness entities rule.
var solidness_rule: AlephVault__WindRose.Contrib.Solidness.EntitiesRule:
	get:
		return _solidness_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "solidness_rule"
		)

## The underlying neighbours entities rule.
var neighbours_rule: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule:
	get:
		return _neighbours_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "neighbours_rule"
		)

## The underlying navigability entities rule.
var navigability_rule: AlephVault__WindRose.Contrib.Navigability.EntitiesRule:
	get:
		return _navigability_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "navigability_rule"
		)

func _init(
	layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer,
	_up_linked: Callable,
	_down_linked: Callable,
	_left_linked: Callable,
	_right_linked: Callable
):
	_blocking_rule = AlephVault__WindRose.Contrib.Blocking.EntitiesRule.new(
		layer
	)
	_solidness_rule = AlephVault__WindRose.Contrib.Solidness.EntitiesRule.new(
		layer.map.size
	)
	_neighbours_rule = AlephVault__WindRose.Contrib.Neighbours.EntitiesRule.new(
		layer, _up_linked, _down_linked, _left_linked, _right_linked
	)
	_navigability_rule = AlephVault__WindRose.Contrib.Navigability.EntitiesRule.new(
		layer
	)
