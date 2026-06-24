extends Node2D


const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction
const _SimpleMapEntity = preload("res://addons/AlephVault.WindRose/contrib/simple/map_entity.gd")
const _VictorianStreetAppliances = AlephVault__WindRose__LPC.Visuals.VictorianStreetAppliances

const _MAP_SIZE := Vector2i(64, 112)
const _ENTITY_SIZE := Vector2i(6, 6)
const _ENTITY_STRIDE := Vector2i(9, 9)
const _GRID_COLUMNS := 3
const _CAMERA_MOVE_SPEED := 320.0
const _MIN_ZOOM := 0.5
const _MAX_ZOOM := 4.0
const _ZOOM_STEP := 0.25


var _items := []
var _selected_index := 0
var _pressed := {}
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
	_fill_floor()
	_build_ui()
	_build_items()
	_update_selection()
	set_process(true)


func _process(delta: float) -> void:
	_update_camera(delta)

	if _just_pressed(KEY_TAB):
		_select((_selected_index + 1) % _items.size())
	if _just_pressed(KEY_1):
		_change_zoom(_ZOOM_STEP)
	if _just_pressed(KEY_2):
		_change_zoom(-_ZOOM_STEP)
	if _just_pressed(KEY_Q):
		_cycle_property("primary")
	if _just_pressed(KEY_S):
		_cycle_state()
	if _just_pressed(KEY_R):
		_cycle_orientation()
	if _just_pressed(KEY_F):
		_cycle_fps()

	_remember_key(KEY_TAB)
	_remember_key(KEY_1)
	_remember_key(KEY_2)
	_remember_key(KEY_Q)
	_remember_key(KEY_S)
	_remember_key(KEY_R)
	_remember_key(KEY_F)


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
	_help_label.text = "Arrows: move camera  1/2: zoom  Tab: select  Q: property  R: orientation  S: off/on  F: FPS"
	_ui_layer.add_child(_help_label)

	_status_label = Label.new()
	_status_label.position = Vector2(20, 40)
	_ui_layer.add_child(_status_label)


func _build_items() -> void:
	_add_item("FancyWideStreetLight", _VictorianStreetAppliances.FancyWideStreetLight, {
		"states": [
			_VictorianStreetAppliances.FancyWideStreetLight.STATE_OFF,
			_VictorianStreetAppliances.FancyWideStreetLight.STATE_ON,
		],
		"has_fps": true,
	})
	_add_item("FancyStreetLight", _VictorianStreetAppliances.FancyStreetLight, {
		"primary": _enum_property("lamp_type", _VictorianStreetAppliances.FancyStreetLight.LampType.size()),
		"states": [
			_VictorianStreetAppliances.FancyStreetLight.STATE_OFF,
			_VictorianStreetAppliances.FancyStreetLight.STATE_ON,
		],
		"has_fps": true,
	})
	_add_item("StreetLight", _VictorianStreetAppliances.StreetLight, {
		"primary": _enum_property("lamp_type", _VictorianStreetAppliances.StreetLight.LampType.size()),
		"states": [
			_VictorianStreetAppliances.StreetLight.STATE_OFF,
			_VictorianStreetAppliances.StreetLight.STATE_ON,
		],
		"has_fps": true,
	})
	_add_item("StreetClock", _VictorianStreetAppliances.StreetClock, {
		"primary": _enum_property("clock_type", _VictorianStreetAppliances.StreetClock.StreetClockType.size()),
	})
	_add_item("BannerPost", _VictorianStreetAppliances.BannerPost, {
		"primary": _enum_property("banner_color", _VictorianStreetAppliances.BannerPost.BannerColor.size()),
	})
	_add_item("WhiteFenceEntrance", _VictorianStreetAppliances.WhiteFenceEntrance)
	_add_item("BigWoodEntrance", _VictorianStreetAppliances.BigWoodEntrance)
	_add_item("WoodEntrance", _VictorianStreetAppliances.WoodEntrance)
	_add_item("GrassEntrance", _VictorianStreetAppliances.GrassEntrance)
	_add_item("GrassRing", _VictorianStreetAppliances.GrassRing)
	_add_item("RoundFountainPool", _VictorianStreetAppliances.RoundFountainPool, {"has_fps": true})
	_add_item("BigSquareFountainPool", _VictorianStreetAppliances.BigSquareFountainPool, {
		"primary": _bool_property("include_fountain"),
		"has_fps": true,
	})
	_add_item("StandaloneFountain", _VictorianStreetAppliances.StandaloneFountain, {
		"primary": _enum_property("fountain_type", _VictorianStreetAppliances.StandaloneFountain.FountainType.size()),
		"has_fps": true,
	})
	_add_item("WallFountain", _VictorianStreetAppliances.WallFountain, {"has_fps": true})
	_add_item("SmallFlowerBed", _VictorianStreetAppliances.SmallFlowerBed, {
		"primary": _enum_property("flower_type", _VictorianStreetAppliances.SmallFlowerBed.FlowerBedType.size()),
		"orientations": [_Direction.DOWN, _Direction.UP, _Direction.LEFT, _Direction.RIGHT],
	})
	_add_item("SmallWoodenPlantPot", _VictorianStreetAppliances.SmallWoodenPlantPot, {
		"primary": _enum_property("content", _VictorianStreetAppliances.SmallWoodenPlantPot.SmallWoodenPlantPotContent.size()),
	})
	_add_item("TinyClayBushPot", _VictorianStreetAppliances.TinyClayBushPot)
	_add_item("SmallHorizontalClayFlowerBed", _VictorianStreetAppliances.SmallHorizontalClayFlowerBed, {
		"primary": _enum_property("content", _VictorianStreetAppliances.SmallHorizontalClayFlowerBed.SmallHorizontalClayFlowerBedContent.size()),
	})
	_add_item("VerticalClayFlowerBed", _VictorianStreetAppliances.VerticalClayFlowerBed, {
		"primary": _enum_property("content", _VictorianStreetAppliances.VerticalClayFlowerBed.VerticalClayFlowerBedContent.size()),
	})
	_add_item("RoundedBushPot", _VictorianStreetAppliances.RoundedBushPot, {
		"primary": _enum_property("content", _VictorianStreetAppliances.RoundedBushPot.RoundedBushPotContent.size()),
	})
	_add_item("BigTreeBed", _VictorianStreetAppliances.BigTreeBed)
	_add_item("HorizontalClayFlowerBed", _VictorianStreetAppliances.HorizontalClayFlowerBed, {
		"primary": _enum_property("content", _VictorianStreetAppliances.HorizontalClayFlowerBed.HorizontalClayFlowerBedContent.size()),
	})
	_add_item("TinyWoodenPlantBed", _VictorianStreetAppliances.TinyWoodenPlantBed, {
		"primary": _enum_property("content", _VictorianStreetAppliances.TinyWoodenPlantBed.TinyWoodenPlantBedContent.size()),
	})
	_add_item("WoodenPlantBed", _VictorianStreetAppliances.WoodenPlantBed, {
		"primary": _enum_property("content", _VictorianStreetAppliances.WoodenPlantBed.WoodenPlantBedContent.size()),
	})
	_add_item("VerticalWoodenPlantBed", _VictorianStreetAppliances.VerticalWoodenPlantBed, {
		"primary": _enum_property("content", _VictorianStreetAppliances.VerticalWoodenPlantBed.VerticalWoodenPlantBedContent.size()),
	})
	_add_item("CeramicPlantPot", _VictorianStreetAppliances.CeramicPlantPot, {
		"primary": _enum_property("content", _VictorianStreetAppliances.CeramicPlantPot.CeramicPlantPotContent.size()),
	})


func _enum_property(name: String, count: int) -> Dictionary:
	return {"name": name, "kind": "enum", "count": count}


func _bool_property(name: String) -> Dictionary:
	return {"name": name, "kind": "bool"}


func _add_item(name: String, visual_script, options := {}) -> void:
	var index := _items.size()
	var cell := Vector2i(index % _GRID_COLUMNS, index / _GRID_COLUMNS) * _ENTITY_STRIDE + Vector2i.ONE
	_paint_entity_footprint(cell, _ENTITY_SIZE)

	var entity = _SimpleMapEntity.new()
	entity.name = name
	entity._size = _ENTITY_SIZE
	entity._initial_position = cell
	_entities_layer.add_child(entity)
	entity.initialize()

	var visual = visual_script.new()
	entity.add_visual(visual)

	var label := Label.new()
	label.name = "Label"
	label.position = Vector2(0, 20)
	label.text = name
	entity.add_child(label)

	var item := {
		"name": name,
		"entity": entity,
		"visual": visual,
		"label": label,
		"state_index": 0,
		"orientation_index": 0,
	}
	for key in options:
		item[key] = options[key]

	_items.push_back(item)
	_apply_orientation(item)
	_apply_state(item)


func _paint_entity_footprint(cell: Vector2i, size: Vector2i) -> void:
	for x in size.x:
		for y in size.y:
			_occupancy_layer.set_cell(cell + Vector2i(x, y), 2, Vector2i.ZERO)


func _select(index: int) -> void:
	_selected_index = index
	_update_selection()


func _update_selection() -> void:
	for index in _items.size():
		var item = _items[index]
		item.visual.modulate = Color(1.35, 1.35, 1.35) if index == _selected_index else Color(0.72, 0.72, 0.72)
		item.label.text = ("> " if index == _selected_index else "") + item.name
	_status_label.text = _describe_item(_items[_selected_index])


func _describe_item(item: Dictionary) -> String:
	var parts := [
		item.name,
		"cell=" + str(item.entity.cell),
		"size=" + str(item.entity.size),
		"state=" + _state_name(item.entity.state),
	]
	if item.has("primary"):
		parts.push_back(_property_text(item, item["primary"]))
	if item.has("secondary"):
		parts.push_back(_property_text(item, item["secondary"]))
	if item.has("orientations"):
		parts.push_back("orientation=" + _direction_name(item.entity.orientation))
	if item.has("has_fps"):
		parts.push_back("fps=" + str(item.visual.fps))
	return " | ".join(parts)


func _property_text(item: Dictionary, config: Dictionary) -> String:
	return config["name"] + "=" + str(item.visual.get(config["name"]))


func _cycle_property(slot: String) -> void:
	var item = _items[_selected_index]
	if not item.has(slot):
		return
	var config = item[slot]
	var property_name: String = config["name"]
	if config["kind"] == "bool":
		item.visual.set(property_name, not bool(item.visual.get(property_name)))
	else:
		var value := (int(item.visual.get(property_name)) + 1) % int(config["count"])
		item.visual.set(property_name, value)
	_update_selection()


func _cycle_state() -> void:
	var item = _items[_selected_index]
	if not item.has("states"):
		return
	item.state_index = (int(item.state_index) + 1) % item.states.size()
	_apply_state(item)
	_update_selection()


func _cycle_fps() -> void:
	var item = _items[_selected_index]
	if not item.has("has_fps"):
		return
	item.visual.fps = 1 + (int(item.visual.fps) % 8)
	_update_selection()


func _cycle_orientation() -> void:
	var item = _items[_selected_index]
	if not item.has("orientations"):
		return
	item.orientation_index = (int(item.orientation_index) + 1) % item.orientations.size()
	_apply_orientation(item)
	_update_selection()


func _apply_state(item: Dictionary) -> void:
	if item.has("states"):
		item.entity.state = item.states[item.state_index]
	else:
		item.entity.state = AlephVault__WindRose.Maps.MapEntity.STATE_IDLE


func _apply_orientation(item: Dictionary) -> void:
	if item.has("orientations"):
		item.entity.orientation = item.orientations[item.orientation_index]
	else:
		item.entity.orientation = _Direction.DOWN


func _direction_name(direction: _Direction) -> String:
	match direction:
		_Direction.UP:
			return "UP"
		_Direction.DOWN:
			return "DOWN"
		_Direction.LEFT:
			return "LEFT"
		_Direction.RIGHT:
			return "RIGHT"
	return "NONE"


func _state_name(state: int) -> String:
	match state:
		AlephVault__WindRose.Maps.MapEntity.STATE_IDLE:
			return "OFF"
		AlephVault__WindRose.Maps.MapEntity.STATE_MOVING:
			return "ON"
	return str(state)


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
