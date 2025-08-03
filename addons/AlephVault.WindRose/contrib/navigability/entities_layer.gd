extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer subclass ensures the navigability
## entities rule is created for it. This rule takes
## the navigability information from cells with two data
## layers named "navigability_type" and "navigability_increments
## and starts accumulating up to 64 navigability types for
## the cells to allow / deny movements of players using a
## specific navigability type.
##
## See AlephVault__WindRose.Contrib.Navigability.EntitiesRule
## for more details.

func _create_rule() -> _EntitiesRule:
	return AlephVault__WindRose.Contrib.Navigability.EntitiesRule.new(
		map
	)
