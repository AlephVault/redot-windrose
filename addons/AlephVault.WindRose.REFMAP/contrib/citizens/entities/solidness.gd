extends AlephVault__WindRose.Contrib.Simple.MapEntity
## Aggregate MapEntity with citizen traits and visual.

const _CitizenTraits = AlephVault__WindRose__REFMAP.Contrib.Citizens.Traits.Citizen
const _CitizenVisual = AlephVault__WindRose__REFMAP.Contrib.Citizens.Visuals.Citizen

## The amount of frames per second to assign to the underlying visual
## the next time the visual is created.
@export var initial_fps: int = 4

static var _traits_schema := _CitizenTraits.new()

var _citizen_visual: _CitizenVisual

func get_traits_schema() -> AlephVault__WindRose.Maps.MapEntityTraits:
	return _traits_schema

func _on_attached(manager: _EntitiesManager, cell: Vector2i):
	super._on_attached(manager, cell)
	_ensure_citizen_visual()

func _ensure_citizen_visual() -> void:
	if not is_instance_valid(current_map) or not is_instance_valid(current_map.visuals_layer):
		return
	_ensure_resolver()
	if not is_instance_valid(_citizen_visual):
		_citizen_visual = _SimpleCitizenVisual.new()
		_citizen_visual.fps = initial_fps
	if _citizen_visual.get_parent() == null:
		add_visual(_citizen_visual)

func _ensure_resolver() -> void:
	var people = AlephVault__WindRose__REFMAP.Visuals.People
	if people.resolver == null or not is_instance_valid(people.resolver):
		people.resolver = AlephVault__WindRose__REFMAP.Utils.DefaultResolver.new()

