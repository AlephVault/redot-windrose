extends AlephVault__WindRose.Core.EntitiesRule
## This is a dummy implementation of an entities
## rule where, actually, no new implementation is
## needed (any movement is accepted, except from
## being out of bounds).

## Tells whether an entity can be attached
## to the map. In this case, the entity has
## the dumb peer rule attached.
func can_attach(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	cell: Vector2i
) -> bool:
	return entity_rule is AlephVault__WindRose.Contrib.Dummy.EntityRule
