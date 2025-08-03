extends AlephVault__WindRose.Maps.MapEntity
## This map entity subclass ensures the navigability
## entity is created for the rule property. This rule
## is initialized from the `navigability` property.
##
## See AlephVault__WindRose.Contrib.Navigability.EntityRule
## for more details.

## The navigability for this entity. It must be
## a number between 0 and 63, being 0 the default
## value (typically meaning: walking).
@export
var _navigability: int = 0

func _create_rule() -> _EntityRule:
	return AlephVault__WindRose.Contrib.Navigability.EntityRule.new(
		size, _navigability, true
	)
