extends Resource
## An EntityRuleSpec has the ability to be assigned
## in the editor while also having the ability to
## create the entity rule object to be used by an
## entity and being managed later.

## Instantiates a rule object for the given entity.
func create_rule(entity: AlephVault__WindRose.Entities.Entity) -> AlephVault__WindRose.Rules.EntityRule:
	assert(false, "EntityRuleSpec::create_rule(entity) must be implemented")
	return null
