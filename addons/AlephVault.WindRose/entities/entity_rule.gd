extends AlephVault__WindRose.Rules.EntityRule
## A Entity's EntityRule is an EntityRule that
## holds a reference to the related entity.

const _Entity = AlephVault__WindRose.Entities.Entity

var _entity: _Entity

## Returns the current entity.
var entity: _Entity:
	get:
		return _entity
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "entity"
		)
