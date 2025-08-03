extends AlephVault__WindRose.Core.EntityRule
## This is the implementation of an entity rule
## which can have its path blocked or not by a
## navigability rule imposed on the involved cells.
## This means that an entity with this rule can
## only move if its navigability type is among the
## types allowed in the attempted cell.

const _Exception = AlephVault__WindRose.Utils.ExceptionUtils.Exception

# The navigability for this entity.
var _navigability: int = 0

## The navigability for this entity. It must be
## a number between 0 and 63, being 0 the default
## value (typically meaning: walking).
var navigability: int:
	get:
		return _navigability
	set(value):
		if value < 0 or value >= 64:
			_Exception.raise(
				"invalid_navigability", "Navigability must be a value"
			)
		else:
			_navigability = value

func _init(
	_size: Vector2i,
	_navigability: int,
	root: bool = true
):
	super._init(_size, true)
	navigability = _navigability
