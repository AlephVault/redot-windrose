extends AlephVault__WindRose.Maps.Layers.EntitiesLayer
## This entities layer subclass ensures the neighbours
## entities rule is created for it. This rule teleports
## objects walking toward the linked boundaries of this
## map to the opposite respective boundary in another
## map (the respectively linked map).
## 
## See AlephVault__WindRose.Contrib.Neighbours.EntitiesRule
## for more details.

func _create_rule() -> _EntitiesRule:
	# TODO implement.
	return AlephVault__WindRose.Contrib.Neighbours.EntitiesRule.new(
		map.size
	)
