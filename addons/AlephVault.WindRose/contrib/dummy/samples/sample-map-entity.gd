extends AlephVault__WindRose.Maps.MapEntity


func _create_rule() -> _EntityRule:
	return AlephVault__WindRose.Contrib.Dummy.EntityRule.new(
		Vector2i(1, 1), true
	)
