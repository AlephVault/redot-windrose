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
var _selected_property_index := 0
var _pressed := {}
var _entity: AlephVault__WindRose.Contrib.Simple.MapEntity
var _visual
var _map: AlephVault__WindRose.Maps.Map
var _entities_layer: AlephVault__WindRose.Contrib.Simple.EntitiesLayer
var _occupancy_layer: TileMapLayer
var _camera: Camera2D
var _ui_layer: CanvasLayer
var _help_label: Label
var _status_label: Label


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
	_update_camera(delta)

	if _just_pressed(KEY_TAB):
		_select_property((_selected_property_index + 1) % _properties.size())
	if _just_pressed(KEY_Q):
		_cycle_property(-1)
	if _just_pressed(KEY_W):
		_cycle_property(1)
	if _just_pressed(KEY_1):
		_change_zoom(_ZOOM_STEP)
	if _just_pressed(KEY_2):
		_change_zoom(-_ZOOM_STEP)

	_remember_key(KEY_TAB)
	_remember_key(KEY_Q)
	_remember_key(KEY_W)
	_remember_key(KEY_1)
	_remember_key(KEY_2)


func _build_properties() -> void:
	_properties = [
		_bool_property("use_bricked_prongs"),
		_enum_property("first_floor_prongs", _Core.FirstFloorProngs.size(), _Core.FirstFloorProngs),
		_enum_property("prong_window_color", _Core.WindowColor.size(), _Core.WindowColor),
		_int_property("prong_window_index", 16),
		_enum_property("non_prong_window_color", _Core.WindowColor.size(), _Core.WindowColor),
		_int_property("non_prong_window_index", 16),
		_enum_property("roof_color", _Core.RoofColor.size(), _Core.RoofColor),
		_enum_property("wall_color", _Core.WallColor.size(), _Core.WallColor),
		_enum_property("light_mode", _Core.LightMode.size(), _Core.LightMode),
		_enum_property("door_shape", _Core.DoorShape.size(), _Core.DoorShape),
		_bool_property("has_doorframe"),
		_enum_property("doorframe_color", _Core.DoorframeColor.size(), _Core.DoorframeColor),
		_int_property("doorframe_index", _Core.DOORFRAME_STYLES),
		_enum_property("doorsteps_color", _Core.DoorstepsColor.size(), _Core.DoorstepsColor),
		_enum_property("stories", _Core.Stories.size(), _Core.Stories),
		_enum_property("depth", _Core.Depth.size(), _Core.Depth),
		_enum_property("design", _Core.Design.size(), _Core.Design),
	]


func _bool_property(name: String) -> Dictionary:
	return {"name": name, "kind": "bool"}


func _int_property(name: String, count: int) -> Dictionary:
	return {"name": name, "kind": "int", "count": count}


func _enum_property(name: String, count: int, names: Dictionary) -> Dictionary:
	return {"name": name, "kind": "enum", "count": count, "names": names}


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
	_help_label.text = "Arrows: move camera  1/2: zoom  Tab: select property  Q/W: previous/next value"
	_ui_layer.add_child(_help_label)

	_status_label = Label.new()
	_status_label.position = Vector2(20, 40)
	_ui_layer.add_child(_status_label)


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


func _select_property(index: int) -> void:
	_selected_property_index = index
	_update_status()


func _cycle_property(direction: int) -> void:
	var config: Dictionary = _properties[_selected_property_index]
	var property_name: String = config["name"]
	if config["kind"] == "bool":
		_visual.set(property_name, not bool(_visual.get(property_name)))
	else:
		var count := int(config["count"])
		var value := posmod(int(_visual.get(property_name)) + direction, count)
		_visual.set(property_name, value)
	_update_status()


func _update_status() -> void:
	var property: Dictionary = _properties[_selected_property_index]
	var parts := [
		"Mansion",
		"property %d/%d" % [_selected_property_index + 1, _properties.size()],
		_property_text(property),
	]
	_status_label.text = " | ".join(parts)


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


func _just_pressed(key: Key) -> bool:
	return Input.is_physical_key_pressed(key) and not bool(_pressed.get(key, false))


func _remember_key(key: Key) -> void:
	_pressed[key] = Input.is_physical_key_pressed(key)
