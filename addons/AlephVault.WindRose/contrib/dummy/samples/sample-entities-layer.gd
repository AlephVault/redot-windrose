extends AlephVault__WindRose.Maps.Layers.EntitiesLayer


func _create_rule() -> _EntitiesRule:
	return AlephVault__WindRose.Contrib.Dummy.EntitiesRule.new(
		Vector2(5, 5), true
	)
