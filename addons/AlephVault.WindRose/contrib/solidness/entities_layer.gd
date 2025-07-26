extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer subclass ensures the solidness
## entities rule is created for it.
##
## See AlephVault__WindRose.Contrib.Solidness.EntitiesRule
## for more details.

func _create_rule() -> _EntitiesRule:
	return AlephVault__WindRose.Contrib.Solidness.EntitiesRule.new(
		map.size
	)
