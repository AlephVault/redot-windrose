extends AlephVault__WindRose.Contrib.Simple.MapEntity
## Aggregate Simple MapEntity with Simple citizen traits and visual.

const _SimpleCitizenTraits = AlephVault__WindRose__REFMAP.Contrib.Citizens.Traits.Simple
const _SimpleCitizenVisual = AlephVault__WindRose__REFMAP.Contrib.Citizens.Visuals.Simple

static var _traits_schema := _SimpleCitizenTraits.new()

var _citizen_visual: _SimpleCitizenVisual

func get_traits_schema() -> AlephVault__WindRose.Maps.MapEntityTraits:
	return _traits_schema

func _on_attached(manager: _EntitiesManager, cell: Vector2i):
	super._on_attached(manager, cell)
	_ensure_citizen_visual()

func _ensure_citizen_visual() -> void:
	if not is_instance_valid(current_map) or not is_instance_valid(current_map.visuals_layer):
		return
	if not is_instance_valid(_citizen_visual):
		_citizen_visual = _SimpleCitizenVisual.new()
	if _citizen_visual.get_parent() == null:
		add_visual(_citizen_visual)
