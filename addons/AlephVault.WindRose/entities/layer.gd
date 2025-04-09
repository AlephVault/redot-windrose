extends AlephVault__WindRose.Maps.Layer
## An entities layer handles the entities
## that are inside, via some custom logic
## provided by the associated rule, which
## is spawned by the attached resource.

func _z_index():
	return 20

@export var _rule_spec: AlephVault__WindRose.Rules.EntitiesRuleSpec

var _rule: AlephVault__WindRose.Rules.EntitiesRule

## Returns the associated rule, perhaps
## creating it first.
var rule:
	get:
		if _rule == null:
			assert(_rule_spec != null, "The rule must be set for Entity objects")
			_rule = _rule_spec.create_rule(self)
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Layer", "rule"
		)

# TODO continue.
