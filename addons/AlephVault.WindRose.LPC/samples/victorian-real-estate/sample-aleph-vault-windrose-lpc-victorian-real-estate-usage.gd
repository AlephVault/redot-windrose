extends Node2D

const _SimpleMapEntity = preload("res://addons/AlephVault.WindRose/contrib/simple/map_entity.gd")
const _VictorianRealEstate = AlephVault__WindRose__LPC.Visuals.VictorianRealEstate
const _Core = preload("res://addons/AlephVault.WindRose.LPC/visuals/victorian-real-estate/mansion_parts/core.gd")

const _MAP_SIZE := Vector2i(40, 40)
const _ENTITY_CELL := Vector2i(11, 11)
const _ENTITY_SIZE := Vector2i(18, 18)
const _CAMERA_MOVE_SPEED := 320.0
const _MIN_ZOOM := 0.5
const _MAX_ZOOM := 4.0
const _ZOOM_STEP := 0.25

var _properties := []
var _key_properties := {}
var _last_property_index := 0
var _entity: AlephVault__WindRose.Contrib.Simple.MapEntity
var _visual
var _map: AlephVault__WindRose.Maps.Map
var _entities_layer: AlephVault__WindRose.Contrib.Simple.EntitiesLayer
var _occupancy_layer: TileMapLayer
var _camera: Camera2D
var _ui_layer: CanvasLayer
var _help_label: Label
var _keys_label: Label
var _status_label: Label
var _clock_label: Label
var _update_clock := 0.0


func _ready() -> void:
	_map = $Map
	_entities_layer = $Map/EntitiesLayer
	_occupancy_layer = $Map/FloorLayer/Occupancy
	_camera = $Camera2D
	_build_properties()
	_fill_floor()
	_build_ui()
	_build_mansion()
	_update_status()
	set_process(true)


func _process(delta: float) -> void:
	_update_clock += delta
	_update_camera(delta)
	_refresh_clock_label()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	if not event.pressed or event.echo:
		return

	match event.physical_keycode:
		KEY_1:
			_change_zoom(_ZOOM_STEP)
		KEY_2:
			_change_zoom(-_ZOOM_STEP)
		KEY_Z:
			_change_zoom(_ZOOM_STEP)
		KEY_X:
			_change_zoom(-_ZOOM_STEP)
		_:
			if not _key_properties.has(event.physical_keycode):
				return
			_cycle_property(int(_key_properties[event.physical_keycode]))

	get_viewport().set_input_as_handled()


func _build_properties() -> void:
	_properties = [
		_bool_property(KEY_Q, "Q", "use_bricked_prongs"),
		_enum_property(KEY_W, "W", "first_floor_prongs", _Core.FirstFloorProngs.size(), _Core.FirstFloorProngs),
		_enum_property(KEY_E, "E", "prong_window_color", _Core.WindowColor.size(), _Core.WindowColor),
		_int_property(KEY_R, "R", "prong_window_index", 16),
		_enum_property(KEY_T, "T", "non_prong_window_color", _Core.WindowColor.size(), _Core.WindowColor),
		_int_property(KEY_Y, "Y", "non_prong_window_index", 16),
		_enum_property(KEY_U, "U", "roof_color", _Core.RoofColor.size(), _Core.RoofColor),
		_enum_property(KEY_I, "I", "wall_color", _Core.WallColor.size(), _Core.WallColor),
		_enum_property(KEY_O, "O", "light_mode", _Core.LightMode.size(), _Core.LightMode),
		_enum_property(KEY_P, "P", "door_shape", _Core.DoorShape.size(), _Core.DoorShape),
		_bool_property(KEY_A, "A", "has_doorframe"),
		_enum_property(KEY_S, "S", "doorframe_color", _Core.DoorframeColor.size(), _Core.DoorframeColor),
		_int_property(KEY_D, "D", "doorframe_index", _Core.DOORFRAME_STYLES),
		_enum_property(KEY_F, "F", "doorsteps_color", _Core.DoorstepsColor.size(), _Core.DoorstepsColor),
		_enum_property(KEY_G, "G", "stories", _Core.Stories.size(), _Core.Stories),
		_enum_property(KEY_H, "H", "depth", _Core.Depth.size(), _Core.Depth),
		_enum_property(KEY_J, "J", "design", _Core.Design.size(), _Core.Design),
	]
	_key_properties = {}
	for index in _properties.size():
		_key_properties[_properties[index]["key"]] = index


func _bool_property(key: Key, key_name: String, name: String) -> Dictionary:
	return {"key": key, "key_name": key_name, "name": name, "kind": "bool"}


func _int_property(key: Key, key_name: String, name: String, count: int) -> Dictionary:
	return {"key": key, "key_name": key_name, "name": name, "kind": "int", "count": count}


func _enum_property(key: Key, key_name: String, name: String, count: int, names: Dictionary) -> Dictionary:
	return {"key": key, "key_name": key_name, "name": name, "kind": "enum", "count": count, "names": names}


func _fill_floor() -> void:
	var floor: TileMapLayer = $Map/FloorLayer/Floor
	for x in _MAP_SIZE.x:
		for y in _MAP_SIZE.y:
			floor.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)


func _build_ui() -> void:
	_ui_layer = CanvasLayer.new()
	add_child(_ui_layer)

	_help_label = Label.new()
	_help_label.position = Vector2(20, 14)
	_help_label.text = "Arrows: move camera  1/2 or Z/X: zoom  Property keys cycle forward"
	_ui_layer.add_child(_help_label)

	_keys_label = Label.new()
	_keys_label.position = Vector2(20, 40)
	_ui_layer.add_child(_keys_label)

	_status_label = Label.new()
	_status_label.position = Vector2(20, 110)
	_ui_layer.add_child(_status_label)

	_clock_label = Label.new()
	_clock_label.position = Vector2(20, 135)
	_ui_layer.add_child(_clock_label)
	_update_keys_label()


func _build_mansion() -> void:
	_paint_entity_footprint(_ENTITY_CELL, _ENTITY_SIZE)

	_entity = _SimpleMapEntity.new()
	_entity.name = "Mansion"
	_entity._size = _ENTITY_SIZE
	_entity._initial_position = _ENTITY_CELL
	_entities_layer.add_child(_entity)
	_entity.initialize()

	_visual = _VictorianRealEstate.Mansion.new()
	_entity.add_visual(_visual)


func _paint_entity_footprint(cell: Vector2i, size: Vector2i) -> void:
	for x in size.x:
		for y in size.y:
			_occupancy_layer.set_cell(cell + Vector2i(x, y), 2, Vector2i.ZERO)


func _cycle_property(index: int) -> void:
	_last_property_index = index
	var config: Dictionary = _properties[index]
	var property_name: String = config["name"]
	if config["kind"] == "bool":
		_visual.set(property_name, not bool(_visual.get(property_name)))
	else:
		var count := int(config["count"])
		var value := posmod(int(_visual.get(property_name)) + 1, count)
		_visual.set(property_name, value)
	_update_status()


func _update_status() -> void:
	var property: Dictionary = _properties[_last_property_index]
	var parts := [
		"Mansion",
		"last key=" + property["key_name"],
		_property_text(property),
	]
	_status_label.text = " | ".join(parts)


func _refresh_clock_label() -> void:
	_clock_label.text = "sample _process clock=%.3f" % _update_clock


func _update_keys_label() -> void:
	var rows := []
	for config in _properties:
		rows.push_back(config["key_name"] + ": " + config["name"])
	_keys_label.text = "  ".join(rows.slice(0, 9)) + "\n" + "  ".join(rows.slice(9))


func _property_text(config: Dictionary) -> String:
	var property_name: String = config["name"]
	var value = _visual.get(property_name) if _visual != null else 0
	if config["kind"] == "enum":
		return property_name + "=" + _enum_value_name(config["names"], int(value))
	return property_name + "=" + str(value)


func _enum_value_name(names: Dictionary, value: int) -> String:
	for key in names:
		if int(names[key]) == value:
			return key
	return str(value)


func _update_camera(delta: float) -> void:
	var movement := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_LEFT):
		movement.x -= 1
	if Input.is_physical_key_pressed(KEY_RIGHT):
		movement.x += 1
	if Input.is_physical_key_pressed(KEY_UP):
		movement.y -= 1
	if Input.is_physical_key_pressed(KEY_DOWN):
		movement.y += 1

	if movement != Vector2.ZERO:
		_camera.position += movement.normalized() * _CAMERA_MOVE_SPEED * delta / _camera.zoom.x


func _change_zoom(delta: float) -> void:
	var next_zoom := clampf(_camera.zoom.x + delta, _MIN_ZOOM, _MAX_ZOOM)
	_camera.zoom = Vector2(next_zoom, next_zoom)
