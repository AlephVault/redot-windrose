extends AlephVault__WindRose.Maps.MapEntity
## This map entity subclass ensures the dummy
## entity rule is created for it.

func _create_rule() -> _EntityRule:
	return AlephVault__WindRose.Contrib.Dummy.EntityRule.new(
		size, true
	)
