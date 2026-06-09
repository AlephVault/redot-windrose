extends AlephVault__WindRose.Contrib.Navigability.MapEntity
## Navigability MapEntity with Standard citizen traits and visual.

const _StandardCitizenTraits = AlephVault__WindRose__REFMAP.Contrib.Citizens.Traits.Standard
const _StandardCitizenVisual = AlephVault__WindRose__REFMAP.Contrib.Citizens.Visuals.Standard

static var _traits_schema := _StandardCitizenTraits.new()

var _citizen_visual: _StandardCitizenVisual

func get_traits_schema() -> AlephVault__WindRose.Maps.MapEntityTraits:
	return _traits_schema

func _on_attached(manager: _EntitiesManager, cell: Vector2i):
	super._on_attached(manager, cell)
	_ensure_citizen_visual()

func _ensure_citizen_visual() -> void:
	if not is_instance_valid(current_map) or not is_instance_valid(current_map.visuals_layer):
		return
	if not is_instance_valid(_citizen_visual):
		_citizen_visual = _StandardCitizenVisual.new()
	if _citizen_visual.get_parent() == null:
		add_visual(_citizen_visual)
