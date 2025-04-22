extends Resource
## An EntitiesRuleSpec has the ability
## to be specified as a property in the
## editor while also having a method to
## instantiate the underlying entities
## rule to be used by an EntitiesManager
## object later.

## Instantiates a rule object for the given entity.
func create_rule(
	entities_layer: AlephVault__WindRose.Entities.Layer
) -> AlephVault__WindRose.Core.EntitiesRule:
	assert(false, "EntitiesRuleSpec::create_rule(entities_layer) must be implemented")
	return null
