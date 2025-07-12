extends AlephVault__WindRose.Resources.EntitiesRuleSpec


## Instantiates a rule object for the given entity.
func create_rule(
	entities_layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer
) -> AlephVault__WindRose.Core.EntitiesRule:
	return AlephVault__WindRose.Contrib.Dummy.EntitiesRule.new(
		entities_layer.map.size
	)
