extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer subclass ensures the blocking
## entities rule is created for it. This rule takes
## the block information from cells with a data layer
## named "blocking" having true - these cells will
## block the movement in any direction.
##
## See AlephVault__WindRose.Contrib.Blocking.EntitiesRule
## for more details.

func _create_rule() -> _EntitiesRule:
	return AlephVault__WindRose.Contrib.Blocking.EntitiesRule.new(
		map
	)
