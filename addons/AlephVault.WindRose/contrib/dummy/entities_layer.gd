extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer subclass ensures the dummy
## entities rule is created for it.

func _create_rule() -> _EntitiesRule:
	return AlephVault__WindRose.Contrib.Dummy.EntitiesRule.new(
		map.size
	)
