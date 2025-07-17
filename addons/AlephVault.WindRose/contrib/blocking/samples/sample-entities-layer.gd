extends AlephVault__WindRose.Maps.Layers.EntitiesLayer


func _create_rule() -> _EntitiesRule:
	return AlephVault__WindRose.Contrib.Blocking.EntitiesRule.new(
		map
	)
