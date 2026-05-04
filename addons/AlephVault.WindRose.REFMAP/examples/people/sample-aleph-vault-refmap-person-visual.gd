@tool
extends AlephVault__WindRose__REFMAP.Visuals.People.Standard

const _COMPONENT_COLORS := [
	ComponentColor.Black,
	ComponentColor.Blue,
	ComponentColor.DarkBrown,
	ComponentColor.Green,
	ComponentColor.LightBrown,
	ComponentColor.Pink,
	ComponentColor.Purple,
	ComponentColor.Red,
	ComponentColor.White,
	ComponentColor.Yellow,
]

const _BODY_COLORS := [
	BodyColor.White,
	BodyColor.Black,
	BodyColor.Yellow,
	BodyColor.Orange,
	BodyColor.Blue,
	BodyColor.Red,
	BodyColor.Green,
	BodyColor.Purple,
]

var _body_index: int = 0
var _component_indices := {}
var _color_indices := {}
var _components := {}

func _init() -> void:
	super._init()
	_define_components()
	sex = Sex.Male

func _ready() -> void:
	_ensure_resolver()
	_apply_initial_setup()
	super._ready()

func _setup():
	sex = Sex.Male
	super._setup()

func _ensure_resolver() -> void:
	var people = AlephVault__WindRose__REFMAP.Visuals.People
	if people.Base.resolver == null or not is_instance_valid(people.Base.resolver):
		people.Base.resolver = AlephVault__WindRose__REFMAP.Utils.DefaultResolver.new()
	resolver = people.Base.resolver

func _resolver() -> Object:
	_ensure_resolver()
	return AlephVault__WindRose__REFMAP.Visuals.People.Base.resolver

func _define_components() -> void:
	_components = {
		"hair": {
			"property": "hair",
			"color_property": "hair_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"],
		},
		"hair_tail": {
			"property": "hair_tail",
			"color_property": "hair_tail_color",
			"keys": [null, "7"],
		},
		"hat": {
			"property": "hat",
			"color_property": "hat_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7"],
		},
		"boots": {
			"property": "boots",
			"color_property": "boots_color",
			"keys": [null, "1", "2", "3"],
		},
		"pants": {
			"property": "pants",
			"color_property": "pants_color",
			"keys": [null, "1", "2", "3", "4", "5"],
		},
		"shirt": {
			"property": "shirt",
			"color_property": "shirt_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
		},
		"chest": {
			"property": "chest",
			"color_property": "chest_color",
			"keys": [null, "1", "2", "3"],
		},
		"waist": {
			"property": "waist",
			"color_property": "waist_color",
			"keys": [null, "1", "2", "3", "4"],
		},
		"arms": {
			"property": "arms",
			"color_property": "arms_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8"],
		},
		"long_shirt": {
			"property": "long_shirt",
			"color_property": "long_shirt_color",
			"keys": [null, "1", "2", "3", "4", "5", "6", "7", "8", "9"],
		},
		"shoulders": {
			"property": "shoulders",
			"color_property": "shoulders_color",
			"keys": [null, "1", "2", "3", "4"],
		},
	}
	for component_name in _components.keys():
		_component_indices[component_name] = 0
		_color_indices[component_name] = 0

func _apply_initial_setup() -> void:
	sex = Sex.Male
	body = _BODY_COLORS[_body_index]
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
	set(setup["color_property"], _COMPONENT_COLORS[color_index])
	set(setup["property"], keys[key_index])

func _cycle_body() -> void:
	sex = Sex.Male
	_body_index = (_body_index + 1) % _BODY_COLORS.size()
	body = _BODY_COLORS[_body_index]

func _cycle_component(component_name: String) -> void:
	sex = Sex.Male
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
