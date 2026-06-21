extends Node2D


const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction
const _MapEntity = AlephVault__WindRose.Maps.MapEntity
const _WoodenFurniture = AlephVault__WindRose__LPC.Visuals.WoodenFurniture

const _CELL_SIZE := Vector2(32, 32)
const _ITEM_SPACING := Vector2(128, 132)
const _GRID_ORIGIN := Vector2(48, 140)
const _GRID_COLUMNS := 6


var _items := []
var _selected_index := 0
var _pressed := {}
var _help_label: Label
var _status_label: Label


func _ready() -> void:
	_build_ui()
	_build_items()
	_update_selection()
	set_process(true)


func _process(delta: float) -> void:
	for item in _items:
		item.visual.update(delta)

	if _just_pressed(KEY_TAB):
		_select((_selected_index + 1) % _items.size())
	if _just_pressed(KEY_Q):
		_cycle_property("primary")
	if _just_pressed(KEY_W):
		_cycle_property("secondary")
	if _just_pressed(KEY_E):
		_cycle_tone()
	if _just_pressed(KEY_R):
		_cycle_orientation()
	if _just_pressed(KEY_F):
		_cycle_fps()

	_remember_key(KEY_TAB)
	_remember_key(KEY_Q)
	_remember_key(KEY_W)
	_remember_key(KEY_E)
	_remember_key(KEY_R)
	_remember_key(KEY_F)


func _build_ui() -> void:
	_help_label = Label.new()
	_help_label.position = Vector2(20, 14)
	_help_label.text = "Tab: select  Q: primary property  W: secondary property  E: tone  R: orientation  F: clock FPS"
	add_child(_help_label)

	_status_label = Label.new()
	_status_label.position = Vector2(20, 40)
	add_child(_status_label)


func _build_items() -> void:
	_add_item("KitchenWideDesk", _WoodenFurniture.KitchenWideDesk, Vector2i(2, 2))
	_add_item("KitchenDesk", _WoodenFurniture.KitchenDesk, Vector2i(1, 2))
	_add_item("KitchenSink", _WoodenFurniture.KitchenSink, Vector2i(1, 2))
	_add_item("KitchenStove", _WoodenFurniture.KitchenStove, Vector2i(1, 2))
	_add_item("KitchenShelvedDesk", _WoodenFurniture.KitchenShelvedDesk, Vector2i(1, 2))
	_add_item("KitchenSidedWideDesk", _WoodenFurniture.KitchenSidedWideDesk, Vector2i(1, 3), {
		"orientations": [_Direction.LEFT, _Direction.RIGHT],
	})
	_add_item("BigDesk", _WoodenFurniture.BigDesk, Vector2i(2, 2), {
		"primary": _enum_property("desk_type", _WoodenFurniture.BigDesk.BigDeskType.size()),
	})
	_add_item("SidedBigDesk", _WoodenFurniture.SidedBigDesk, Vector2i(1, 3), {
		"orientations": [_Direction.RIGHT, _Direction.LEFT],
	})
	_add_item("Clock", _WoodenFurniture.Clock, Vector2i(1, 3), {"has_fps": true})
	_add_item("Fireplace", _WoodenFurniture.Fireplace, Vector2i(3, 3), {
		"primary": _enum_property("fireplace_type", _WoodenFurniture.Fireplace.FireplaceType.size()),
	})
	_add_item("ChurchSeat", _WoodenFurniture.ChurchSeat, Vector2i(3, 1), {
		"orientations": [_Direction.DOWN, _Direction.UP],
	})
	_add_item("GrandPiano", _WoodenFurniture.GrandPiano, Vector2i(2, 3))
	_add_item("UprightPiano", _WoodenFurniture.UprightPiano, Vector2i(2, 3))
	_add_item("OrganPiano", _WoodenFurniture.OrganPiano, Vector2i(3, 3))
	_add_item("HorizontalPlankTable", _WoodenFurniture.HorizontalPlankTable, Vector2i(3, 2), {
		"orientations": [_Direction.DOWN, _Direction.UP],
	})
	_add_item("VerticalPlankTable", _WoodenFurniture.VerticalPlankTable, Vector2i(1, 3), {
		"orientations": [_Direction.RIGHT, _Direction.LEFT],
	})
	_add_item("HorizontalPlankBank", _WoodenFurniture.HorizontalPlankBank, Vector2i(2, 1), {
		"orientations": [_Direction.DOWN, _Direction.UP],
	})
	_add_item("VerticalPlankBank", _WoodenFurniture.VerticalPlankBank, Vector2i(1, 3), {
		"orientations": [_Direction.RIGHT, _Direction.LEFT],
	})
	_add_item("BigPlankTable", _WoodenFurniture.BigPlankTable, Vector2i(3, 3))
	_add_item("VerticalFurniture", _WoodenFurniture.VerticalFurniture, Vector2i(1, 3), {
		"primary": _enum_property("furniture_type", _WoodenFurniture.VerticalFurniture.VerticalFurnitureType.size()),
		"secondary": _enum_property("furniture_legs_type", _WoodenFurniture.VerticalFurniture.VerticalFurnitureLegsType.size()),
	})
	_add_item("RoundTable", _WoodenFurniture.RoundTable, Vector2i(2, 2))
	_add_item("Stool1", _WoodenFurniture.Stool1, Vector2i(1, 1), {"primary": _bool_property("worn")})
	_add_item("Stool2", _WoodenFurniture.Stool2, Vector2i(1, 1), {"primary": _bool_property("worn")})
	_add_item("TwinBed", _WoodenFurniture.TwinBed, Vector2i(1, 2), {
		"primary": _enum_property("bed_type", _WoodenFurniture.TwinBed.BedType.size()),
	})
	_add_item("Chair", _WoodenFurniture.Chair, Vector2i(1, 1), {
		"primary": _enum_property("chair_type", _WoodenFurniture.Chair.ChairType.size()),
		"secondary": _bool_property("worn"),
		"orientations": [_Direction.DOWN, _Direction.UP, _Direction.LEFT, _Direction.RIGHT],
	})
	_add_item("WideShelving", _WoodenFurniture.WideShelving, Vector2i(2, 2), {"primary": _bool_property("worn")})
	_add_item("WideGondola", _WoodenFurniture.WideGondola, Vector2i(2, 2), {"primary": _bool_property("worn")})
	_add_item("WideMidDrawers", _WoodenFurniture.WideMidDrawers, Vector2i(2, 2), {"primary": _bool_property("worn")})
	_add_item("WideSmallShelving", _WoodenFurniture.WideSmallShelving, Vector2i(2, 2), {"primary": _bool_property("worn")})
	_add_item("WideSmallDesk", _WoodenFurniture.WideSmallDesk, Vector2i(2, 2), {"primary": _bool_property("worn")})
	_add_item("WideWardrobe", _WoodenFurniture.WideWardrobe, Vector2i(2, 2), {"primary": _bool_property("worn")})
	_add_item("SmallShelving", _WoodenFurniture.SmallShelving, Vector2i(1, 2), {"primary": _bool_property("worn")})
	_add_item("SmallWardrobe", _WoodenFurniture.SmallWardrobe, Vector2i(1, 2), {"primary": _bool_property("worn")})
	_add_item("SmallDrawer", _WoodenFurniture.SmallDrawer, Vector2i(1, 1), {"primary": _bool_property("worn")})
	_add_item("NightStand", _WoodenFurniture.NightStand, Vector2i(1, 1), {"primary": _bool_property("worn")})
	_add_item("WideSmallDrawer", _WoodenFurniture.WideSmallDrawer, Vector2i(2, 1), {"primary": _bool_property("worn")})
	_add_item("Shelving", _WoodenFurniture.Shelving, Vector2i(1, 2))
	_add_item("Drawers", _WoodenFurniture.Drawers, Vector2i(1, 2))
	_add_item("MidDrawers", _WoodenFurniture.MidDrawers, Vector2i(1, 2))
	_add_item("ChessTable", _WoodenFurniture.ChessTable, Vector2i(1, 1))
	_add_item("BigWardrobe", _WoodenFurniture.BigWardrobe, Vector2i(2, 3))
	_add_item("BigTable", _WoodenFurniture.BigTable, Vector2i(3, 3))
	_add_item("VerticalMidBank", _WoodenFurniture.VerticalMidBank, Vector2i(1, 2))
	_add_item("HorizontalMidBank", _WoodenFurniture.HorizontalMidBank, Vector2i(2, 1))
	_add_item("Column", _WoodenFurniture.Column, Vector2i(1, 3))
	_add_item("TinyDrawer", _WoodenFurniture.TinyDrawer, Vector2i(1, 1), {
		"primary": _enum_property("drawer_type", _WoodenFurniture.TinyDrawer.TinyDrawerType.size()),
	})
	_add_item("DoubleTinyDrawer", _WoodenFurniture.DoubleTinyDrawer, Vector2i(1, 1), {
		"primary": _enum_property("drawer_type", _WoodenFurniture.DoubleTinyDrawer.TinyDrawerType.size()),
	})
	_add_item("VerticalDoubleBunkBed", _WoodenFurniture.VerticalDoubleBunkBed, Vector2i(2, 3))
	_add_item("HorizontalBunkBed", _WoodenFurniture.HorizontalBunkBed, Vector2i(3, 3))


func _enum_property(name: String, count: int) -> Dictionary:
	return {"name": name, "kind": "enum", "count": count}


func _bool_property(name: String) -> Dictionary:
	return {"name": name, "kind": "bool"}


func _add_item(name: String, visual_script, size: Vector2i, options := {}) -> void:
	var index := _items.size()
	var container := Node2D.new()
	container.name = name
	container.position = _GRID_ORIGIN + Vector2(index % _GRID_COLUMNS, index / _GRID_COLUMNS) * _ITEM_SPACING
	add_child(container)

	var base := _make_floor(size)
	base.position = Vector2.ZERO
	container.add_child(base)

	var entity := _MapEntity.new()
	var visual = visual_script.new()
	container.add_child(visual)
	visual.setup(entity)
	visual.visible = true

	var label := Label.new()
	label.position = Vector2(0, 34)
	label.text = name
	container.add_child(label)

	var item := {
		"name": name,
		"container": container,
		"entity": entity,
		"visual": visual,
		"label": label,
		"orientation_index": 0,
	}
	for key in options:
		item[key] = options[key]

	_items.push_back(item)
	_apply_orientation(item)


func _make_floor(size: Vector2i) -> Node2D:
	var floor := Node2D.new()
	for x in size.x:
		for y in size.y:
			var rect := ColorRect.new()
			rect.position = Vector2(x, y) * _CELL_SIZE
			rect.size = _CELL_SIZE
			rect.color = Color(0.18, 0.17, 0.15, 1.0)
			floor.add_child(rect)
	return floor


func _select(index: int) -> void:
	_selected_index = index
	_update_selection()


func _update_selection() -> void:
	for index in _items.size():
		var item = _items[index]
		item.container.modulate = Color(1.25, 1.25, 1.25) if index == _selected_index else Color(0.72, 0.72, 0.72)
		item.label.text = ("> " if index == _selected_index else "") + item.name
	_status_label.text = _describe_item(_items[_selected_index])


func _describe_item(item: Dictionary) -> String:
	var parts := [item.name, "tone=" + str(item.visual.tone)]
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


func _cycle_tone() -> void:
	var item = _items[_selected_index]
	item.visual.tone = (int(item.visual.tone) + 1) % _WoodenFurniture.Base.Tone.size()
	_update_selection()


func _cycle_orientation() -> void:
	var item = _items[_selected_index]
	if not item.has("orientations"):
		return
	item.orientation_index = (int(item.orientation_index) + 1) % item.orientations.size()
	_apply_orientation(item)
	_update_selection()


func _cycle_fps() -> void:
	var item = _items[_selected_index]
	if not item.has("has_fps"):
		return
	item.visual.fps = 1 + (int(item.visual.fps) % 8)
	_update_selection()


func _apply_orientation(item: Dictionary) -> void:
	if item.has("orientations"):
		item.entity.orientation = item.orientations[item.orientation_index]
	else:
		item.entity.orientation = _Direction.DOWN


func _direction_name(direction: int) -> String:
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


func _just_pressed(key: Key) -> bool:
	return Input.is_physical_key_pressed(key) and not bool(_pressed.get(key, false))


func _remember_key(key: Key) -> void:
	_pressed[key] = Input.is_physical_key_pressed(key)
