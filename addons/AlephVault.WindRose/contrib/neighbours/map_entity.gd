extends AlephVault__WindRose.Maps.MapEntity
## This map entity subclass ensures the neighbours
## entity rule is created for it. Entities of this
## type, and underlying rule, will get teleported
## when reading a connected end of their map.
##
## See AlephVault__WindRose.Contrib.Neighbours.EntityRule
## for more details.

func _create_rule() -> _EntityRule:
	return AlephVault__WindRose.Contrib.Neighbours.EntityRule.new(
		self, true
	)
