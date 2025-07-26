extends AlephVault__WindRose.Maps.MapEntity
## This map entity subclass ensures the blocking
## entity rule is created for it. Entities of this
## type, and underlying rule, will get blocked by
## blocking tiles in the map.
##
## See AlephVault__WindRose.Contrib.Blocking.EntityRule
## for more details.

func _create_rule() -> _EntityRule:
	return AlephVault__WindRose.Contrib.Blocking.EntityRule.new(
		size, true
	)
