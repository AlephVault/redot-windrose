extends AlephVault__WindRose.Core.EntityRule
## This is the entity rule for the simple
## entity rule. This rule is a convergence
## of the other 4 rules: blocking, solidness,
## neighbours and navigability. It only has
## attributes which are those child rules.
##
## See the following classes for more details:
## - AlephVault__WindRose.Contrib.Solidness.EntityRule
## - AlephVault__WindRose.Contrib.Blocking.EntityRule
## - AlephVault__WindRose.Contrib.Neighbours.EntityRule
## - AlephVault__WindRose.Contrib.Navigability.EntityRule

const _Solidness = AlephVault__WindRose.Contrib.Solidness.EntityRule.Solidness

# The blocking rule.
var _blocking_rule: AlephVault__WindRose.Contrib.Blocking.EntityRule

# The solidness entity rule.
var _solidness_rule: AlephVault__WindRose.Contrib.Solidness.EntityRule

# The navigability entity rule.
var _navigability_rule: AlephVault__WindRose.Contrib.Navigability.EntityRule

# The neighbours entity rule.
var _neighbours_rule: AlephVault__WindRose.Contrib.Neighbours.EntityRule

## The blocking rule.
var blocking_rule: AlephVault__WindRose.Contrib.Blocking.EntityRule:
	get:
		return _blocking_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "blocking_rule"
		)

## The solidness entity rule.
var solidness_rule: AlephVault__WindRose.Contrib.Solidness.EntityRule:
	get:
		return _solidness_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "solidness_rule"
		)

## The navigability entity rule.
var navigability_rule: AlephVault__WindRose.Contrib.Navigability.EntityRule:
	get:
		return _navigability_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "navigability_rule"
		)

## The neighbours entity rule.
var neighbours_rule: AlephVault__WindRose.Contrib.Neighbours.EntityRule:
	get:
		return _neighbours_rule
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "neighbours_rule"
		)

func _forward_on_property_updated(property: String, old_value, new_value):
	on_property_updated.emit(property, old_value, new_value)

func _init(
	map_entity: AlephVault__WindRose.Maps.MapEntity,
	obeys_solidness: bool = true,
	solidness: _Solidness = _Solidness.SOLID,
	mask: String = "",
	optimistic: bool = false,
	_navigability: int = 0,
	root: bool = true
):
	super._init(map_entity.size, root)
	_blocking_rule = AlephVault__WindRose.Contrib.Blocking.EntityRule.new(
		map_entity.size, false
	)
	_solidness_rule = AlephVault__WindRose.Contrib.Solidness.EntityRule.new(
		map_entity, obeys_solidness, solidness,
		mask, optimistic, false
	)
	_solidness_rule.on_property_updated.connect(_forward_on_property_updated)
	_neighbours_rule = AlephVault__WindRose.Contrib.Neighbours.EntityRule.new(
		map_entity, false
	)
	_navigability_rule = AlephVault__WindRose.Contrib.Navigability.EntityRule.new(
		map_entity.size, false
	)
