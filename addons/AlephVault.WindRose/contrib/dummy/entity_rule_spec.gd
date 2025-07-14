extends AlephVault__WindRose.Resources.EntityRuleSpec


@export var sample: int = 42


## Instantiates a rule object for the given entity.
func create_rule(
	entity: AlephVault__WindRose.Maps.MapEntity,
	root: bool = false
) -> AlephVault__WindRose.Core.EntityRule:
	return AlephVault__WindRose.Contrib.Dummy.EntityRule.new(
		entity.entity.size, root
	)
