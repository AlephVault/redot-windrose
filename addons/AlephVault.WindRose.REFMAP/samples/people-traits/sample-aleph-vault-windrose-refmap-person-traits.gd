extends AlephVault__WindRose.Contrib.Simple.MapEntity
## Sample simple-strategy MapEntity exposing traits consumed by a REFMAP people visual.

const _PeopleVisual = AlephVault__WindRose__REFMAP.Visuals.People.Base
const _StandardTraits = AlephVault__WindRose__REFMAP.Traits.People.Standard

static var _traits_schema := _StandardTraits.new()

const _COMPONENT_COLORS := [
	_PeopleVisual.ComponentColor.Black,
	_PeopleVisual.ComponentColor.Blue,
	_PeopleVisual.ComponentColor.DarkBrown,
	_PeopleVisual.ComponentColor.Green,
	_PeopleVisual.ComponentColor.LightBrown,
	_PeopleVisual.ComponentColor.Pink,
	_PeopleVisual.ComponentColor.Purple,
	_PeopleVisual.ComponentColor.Red,
	_PeopleVisual.ComponentColor.White,
	_PeopleVisual.ComponentColor.Yellow,
]

const _BODY_COLORS := [
	_PeopleVisual.BodyColor.White,
	_PeopleVisual.BodyColor.Black,
	_PeopleVisual.BodyColor.Yellow,
	_PeopleVisual.BodyColor.Orange,
	_PeopleVisual.BodyColor.Blue,
	_PeopleVisual.BodyColor.Red,
	_PeopleVisual.BodyColor.Green,
	_PeopleVisual.BodyColor.Purple,
]

var _body_index: int = 0
var _component_indices := {}
var _color_indices := {}
var _components := {}

func _init() -> void:
	_define_components()

func _ready() -> void:
	_ensure_resolver()
	super._ready()
	_apply_initial_setup()

func get_traits_schema() -> AlephVault__WindRose.Maps.MapEntityTraits:
	return _traits_schema

func _ensure_resolver() -> void:
	var people = AlephVault__WindRose__REFMAP.Visuals.People
	if people.Base.resolver == null or not is_instance_valid(people.Base.resolver):
		people.Base.resolver = AlephVault__WindRose__REFMAP.Utils.DefaultResolver.new()

func _define_components() -> void:
	_components = {
		"hair": {
			"property": &"hair",
			"color_property": &"hair_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"],
		},
		"hair_tail": {
			"property": &"hair_tail",
			"color_property": &"hair_tail_color",
			"keys": [null, "7"],
		},
		"hat": {
			"property": &"hat",
			"color_property": &"hat_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7"],
		},
		"boots": {
			"property": &"boots",
			"color_property": &"boots_color",
			"keys": [null, "1", "2", "3"],
		},
		"pants": {
			"property": &"pants",
			"color_property": &"pants_color",
			"keys": [null, "1", "2", "3", "4", "5"],
		},
		"shirt": {
			"property": &"shirt",
			"color_property": &"shirt_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
		},
		"chest": {
			"property": &"chest",
			"color_property": &"chest_color",
			"keys": [null, "1", "2", "3"],
		},
		"waist": {
			"property": &"waist",
			"color_property": &"waist_color",
			"keys": [null, "1", "2", "3", "4"],
		},
		"arms": {
			"property": &"arms",
			"color_property": &"arms_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8"],
		},
		"long_shirt": {
			"property": &"long_shirt",
			"color_property": &"long_shirt_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8", "9"],
		},
		"shoulders": {
			"property": &"shoulders",
			"color_property": &"shoulders_color",
			"keys": [null, "1", "2", "3", "4"],
		},
	}
	for component_name in _components.keys():
		_component_indices[component_name] = 0
		_color_indices[component_name] = 0

func _apply_initial_setup() -> void:
	var setup_traits := {}
	setup_traits[&"sex"] = _PeopleVisual.Sex.Male
	setup_traits[&"body"] = _BODY_COLORS[_body_index]
	traits = setup_traits
	_set_component("hair", 1, 0)
	_set_component("shirt", 1, 1)
	_set_component("pants", 1, 0)
	_set_component("boots", 1, 0)

func _set_component(component_name: String, key_index: int, color_index: int) -> void:
	var setup: Dictionary = _components[component_name]
	var keys: Array = setup["keys"]
	key_index %= keys.size()
	color_index %= _COMPONENT_COLORS.size()
	_component_indices[component_name] = key_index
	_color_indices[component_name] = color_index
	var updated_traits := {}
	updated_traits[setup["color_property"]] = _COMPONENT_COLORS[color_index]
	updated_traits[setup["property"]] = keys[key_index]
	traits = updated_traits

func _cycle_body() -> void:
	_body_index = (_body_index + 1) % _BODY_COLORS.size()
	var updated_traits := {}
	updated_traits[&"sex"] = _PeopleVisual.Sex.Male
	updated_traits[&"body"] = _BODY_COLORS[_body_index]
	traits = updated_traits

func _cycle_component(component_name: String) -> void:
	var setup: Dictionary = _components[component_name]
	var key_index: int = int(_component_indices[component_name]) + 1
	var color_index: int = int(_color_indices[component_name])
	if key_index >= setup["keys"].size():
		key_index = 0
		color_index += 1
	_set_component(component_name, key_index, color_index)

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	if not event.pressed or event.echo:
		return

	match event.keycode:
		KEY_1:
			_cycle_body()
		KEY_2:
			_cycle_component("hair")
		KEY_3:
			_cycle_component("hair_tail")
		KEY_4:
			_cycle_component("hat")
		KEY_5:
			_cycle_component("boots")
		KEY_6:
			_cycle_component("pants")
		KEY_7:
			_cycle_component("shirt")
		KEY_8:
			_cycle_component("chest")
		KEY_9:
			_cycle_component("waist")
		KEY_0:
			_cycle_component("arms")
		KEY_MINUS:
			_cycle_component("long_shirt")
		KEY_EQUAL:
			_cycle_component("shoulders")
