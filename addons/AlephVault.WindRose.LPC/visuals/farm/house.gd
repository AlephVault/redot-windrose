@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _HOUSE_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-house.png")
const _Step := AlephVault__WindRose.Utils.Textures.Step
const _Context := AlephVault__WindRose.Utils.Textures.Context

const _TEXTURE_SIZE := Vector2i(288, 288)
const _BLOCK_SIZE := Vector2i(288, 288)
const _DEFAULT_CACHE_MAX_DISPOSAL_SIZE := 128
const _WINDOW_LIGHTS_ON_POSITION := Vector2i(160, 192)
const _WINDOW_LIGHTS_ON_SIZE := Vector2i(32, 32)
const _WINDOW_LIGHTS_ON_SOURCE_POSITION := Vector2i(1184, 1088)
const _DOORFRAME_SIZE := Vector2i(64, 64)
const _DOORFRAME_POSITION := Vector2i(80, 176)
const _DOORFRAME_ROW_0_SOURCE_POSITION := Vector2i(960, 960)
const _DOORFRAME_ROW_1_SOURCE_POSITION := Vector2i(960, 1024)
const _DOOR_SIZE := Vector2i(32, 48)
const _DOOR_POSITION := Vector2i(96, 192)
const _DOOR_OPEN_ROW_0_SOURCE_POSITION := Vector2i(960, 672)
const _DOOR_OPEN_ROW_1_SOURCE_POSITION := Vector2i(960, 720)
const _DOOR_CLOSED_WITH_WINDOWS_LIGHTS_OFF_ROW_0_SOURCE_POSITION := Vector2i(960, 768)
const _DOOR_CLOSED_WITH_WINDOWS_LIGHTS_OFF_ROW_1_SOURCE_POSITION := Vector2i(960, 816)
const _DOOR_CLOSED_WITH_WINDOWS_LIGHTS_ON_ROW_0_SOURCE_POSITION := Vector2i(1216, 768)
const _DOOR_CLOSED_WITH_WINDOWS_LIGHTS_ON_ROW_1_SOURCE_POSITION := Vector2i(1216, 816)
const _DOOR_CLOSED_WITHOUT_WINDOWS_ROW_0_SOURCE_POSITION := Vector2i(960, 864)
const _DOOR_CLOSED_WITHOUT_WINDOWS_ROW_1_SOURCE_POSITION := Vector2i(960, 912)
const _DOOR_BLACK_RECTANGLE_SOURCE_POSITION := Vector2i(1360, 1040)
const _DOOR_LIGHT_RECTANGLE_SOURCE_POSITION := Vector2i(1360, 976)
const _DOORSTEPS_SIZE := Vector2i(32, 32)
const _DOORSTEPS_POSITION := Vector2i(96, 240)
const _DOORSTEPS_ROW_0_SOURCE_POSITION := Vector2i(960, 1104)


## The brick color used by the house body parts.
enum BrickColor {
	LIGHT_BLUE,
	LIGHT_GRAY,
	GRAY,
	LIGHT_BROWN,
	BROWN,
	RED,
}


## The color of the door. Please note that is
## is different to the color of the doorframes.
enum DoorColor {
	RED,
	YELLOW,
	GREEN,
	BLUE,
	WHITE,
	MID_WHITE,
	MID_DARK,
	DARK,
	BROWN1_LIGHT,
	BROWN1_MID_LIGHT,
	BROWN1_MID_DARK,
	BROWN1_DARK,
	BROWN2_LIGHT,
	BROWN2_MID_LIGHT,
	BROWN2_MID_DARK,
	BROWN2_DARK
}


## The color of the doorframe. Please note that it
## is different to the color of the door.
enum DoorframeColor {
	ORANGE_LIGHT,
	ORANGE_MID,
	ORANGE_DARK,
	BROWN_LIGHT,
	BROWN_MID,
	BROWN_DARK,
	GRAY_LIGHT,
	GRAY_MID,
	GRAY_DARK,
	BLUE_LIGHT,
	BLUE_MID,
	BLUE_DARK
}


## The color of the door stairs. Please note that it
## is different to the color of the bricks and ceiling.
enum DoorstepsColor {
	GRAY_LIGHT,
	GRAY_DARK,
	BLUE_LIGHT,
	BLUE_MID_LIGHT,
	BLUE_MID,
	BLUE_MID_DARK,
	BLUE_DARK
}


const _CEILING_INDICES := [
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0),
	Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1),
]

const _WALLS_INDICES := [
	Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2),
	Vector2i(0, 3), Vector2i(1, 3), Vector2i(2, 3),
]

const _CHIMNEY_INDICES := [
	Vector2i(3, 0), Vector2i(4, 0), Vector2i(5, 0),
	Vector2i(3, 1), Vector2i(4, 1), Vector2i(5, 1),
]


## The LRU cache name used for composed house textures.
@export var texture_cache_name: String = "farm_house":
	set(value):
		var next_value := value.strip_edges()
		assert(next_value != "", "The texture cache name must not be empty")
		if next_value == "":
			return
		if texture_cache_name == next_value:
			return
		_release_texture()
		texture_cache_name = next_value
		_update_sprite()


## The wall color variant.
@export var wall_color: BrickColor = BrickColor.LIGHT_BLUE:
	set(value):
		if wall_color == value:
			return
		_release_texture()
		wall_color = value
		_update_sprite()


## The ceiling color variant.
@export var ceiling_color: BrickColor = BrickColor.LIGHT_BLUE:
	set(value):
		if ceiling_color == value:
			return
		_release_texture()
		ceiling_color = value
		_update_sprite()


## The chimney color variant.
@export var chimney_color: BrickColor = BrickColor.LIGHT_BLUE:
	set(value):
		if chimney_color == value:
			return
		_release_texture()
		chimney_color = value
		_update_sprite()


## Whether the lights are on or not.
@export var lights_on: bool = false:
	set(value):
		if lights_on == value:
			return
		_release_texture()
		lights_on = value
		_update_sprite()


## The door color.
@export var door_color: DoorColor = DoorColor.RED:
	set(value):
		if door_color == value:
			return
		_release_texture()
		door_color = value
		_update_sprite()


## Whether the door is open or not.
@export var door_is_open: bool = false:
	set(value):
		if door_is_open == value:
			return
		_release_texture()
		door_is_open = value
		_update_sprite()


## Whether the door has windows or not.
@export var door_has_windows: bool = false:
	set(value):
		if door_has_windows == value:
			return
		_release_texture()
		door_has_windows = value
		_update_sprite()


## The color of the doorframe.
@export var doorframe_color: DoorframeColor = DoorframeColor.ORANGE_LIGHT:
	set(value):
		if doorframe_color == value:
			return
		_release_texture()
		doorframe_color = value
		_update_sprite()


## Whether the doorframe is used or not.
@export var has_doorframe: bool = true:
	set(value):
		if has_doorframe == value:
			return
		_release_texture()
		has_doorframe = value
		_update_sprite()


## The color of the door steps.
@export var doorsteps_color: DoorstepsColor = DoorstepsColor.GRAY_LIGHT:
	set(value):
		if doorsteps_color == value:
			return
		_release_texture()
		doorsteps_color = value
		_update_sprite()


var _texture_context = null


func _init() -> void:
	_update_sprite()


func _ready() -> void:
	_update_sprite()


func _setup():
	_update_sprite()


func _teardown():
	_release_texture()


func _pause():
	pass


func _resume():
	pass


func _update(_delta: float):
	_update_sprite()


func _validate_property(property: Dictionary) -> void:
	if property.name in [
		"texture",
		"hframes",
		"vframes",
		"frame",
		"frame_coords",
		"region_enabled",
		"region_rect",
		"region_filter_clip_enabled",
	]:
		property.usage = PROPERTY_USAGE_NO_EDITOR


func _ensure_cache(cache_name: String) -> void:
	if not AlephVault__WindRose.Utils.LRU.Registry.has(cache_name):
		AlephVault__WindRose.Utils.LRU.Registry.define(
			cache_name, _DEFAULT_CACHE_MAX_DISPOSAL_SIZE
		)


func _make_step(part: String, source_rect: Rect2i, target_position: Vector2i = Vector2i.ZERO) -> Object:
	return _Step.new(part, _HOUSE_TEXTURE, source_rect, target_position)


func _make_row6_rect(row_0_origin: Vector2i, row_1_origin: Vector2i, index: int, size: Vector2i) -> Rect2i:
	var row := int(index / 6)
	var column := index % 6
	var origin := row_0_origin if row == 0 else row_1_origin
	return Rect2i(origin + Vector2i(size.x * column, 0), size)


func _make_row8_rect(row_0_origin: Vector2i, row_1_origin: Vector2i, index: int, size: Vector2i) -> Rect2i:
	var row := int(index / 8)
	var column := index % 8
	var origin := row_0_origin if row == 0 else row_1_origin
	return Rect2i(origin + Vector2i(size.x * column, 0), size)


func _make_row7_rect(row_0_origin: Vector2i, index: int, size: Vector2i) -> Rect2i:
	return Rect2i(row_0_origin + Vector2i(size.x * index, 0), size)


func _build_context():
	var steps := [
		_make_step(
			"wall_%d" % int(wall_color),
			Rect2i(_BLOCK_SIZE * _WALLS_INDICES[int(wall_color)], _BLOCK_SIZE)
		),
		_make_step(
			"ceiling_%d" % int(ceiling_color),
			Rect2i(_BLOCK_SIZE * _CEILING_INDICES[int(ceiling_color)], _BLOCK_SIZE)
		),
		_make_step(
			"chimney_%d" % int(chimney_color),
			Rect2i(_BLOCK_SIZE * _CHIMNEY_INDICES[int(chimney_color)], _BLOCK_SIZE)
		),
	]
	if has_doorframe:
		steps.append(
			_make_step(
				"doorframe_%d" % int(doorframe_color),
				_make_row6_rect(
					_DOORFRAME_ROW_0_SOURCE_POSITION,
					_DOORFRAME_ROW_1_SOURCE_POSITION,
					int(doorframe_color),
					_DOORFRAME_SIZE
				),
				_DOORFRAME_POSITION
			)
		)
	if door_is_open:
		steps.append(
			_make_step(
				"door_back_%s" % ("lights_on" if lights_on else "lights_off"),
				Rect2i(
					_DOOR_LIGHT_RECTANGLE_SOURCE_POSITION if lights_on else _DOOR_BLACK_RECTANGLE_SOURCE_POSITION,
					_DOOR_SIZE
				),
				_DOOR_POSITION
			)
		)
		steps.append(
			_make_step(
				"door_open_%d" % int(door_color),
				_make_row8_rect(
					_DOOR_OPEN_ROW_0_SOURCE_POSITION,
					_DOOR_OPEN_ROW_1_SOURCE_POSITION,
					int(door_color),
					_DOOR_SIZE
				),
				_DOOR_POSITION
			)
		)
	elif door_has_windows:
		steps.append(
			_make_step(
				"door_closed_windows_%d_%s" % [int(door_color), "lights_on" if lights_on else "lights_off"],
				_make_row8_rect(
					_DOOR_CLOSED_WITH_WINDOWS_LIGHTS_ON_ROW_0_SOURCE_POSITION if lights_on else _DOOR_CLOSED_WITH_WINDOWS_LIGHTS_OFF_ROW_0_SOURCE_POSITION,
					_DOOR_CLOSED_WITH_WINDOWS_LIGHTS_ON_ROW_1_SOURCE_POSITION if lights_on else _DOOR_CLOSED_WITH_WINDOWS_LIGHTS_OFF_ROW_1_SOURCE_POSITION,
					int(door_color),
					_DOOR_SIZE
				),
				_DOOR_POSITION
			)
		)
	else:
		steps.append(
			_make_step(
				"door_closed_solid_%d" % int(door_color),
				_make_row8_rect(
					_DOOR_CLOSED_WITHOUT_WINDOWS_ROW_0_SOURCE_POSITION,
					_DOOR_CLOSED_WITHOUT_WINDOWS_ROW_1_SOURCE_POSITION,
					int(door_color),
					_DOOR_SIZE
				),
				_DOOR_POSITION
			)
		)
	steps.append(
		_make_step(
			"doorsteps_%d" % int(doorsteps_color),
			_make_row7_rect(
				_DOORSTEPS_ROW_0_SOURCE_POSITION,
				int(doorsteps_color),
				_DOORSTEPS_SIZE
			),
			_DOORSTEPS_POSITION
		)
	)
	if lights_on:
		steps.append(
			_make_step(
				"window_lights_on",
				Rect2i(_WINDOW_LIGHTS_ON_SOURCE_POSITION, _WINDOW_LIGHTS_ON_SIZE),
				_WINDOW_LIGHTS_ON_POSITION
			)
		)
	return _Context.new(_TEXTURE_SIZE.x, _TEXTURE_SIZE.y, steps)


func _release_texture() -> void:
	if _texture_context != null and texture_cache_name.strip_edges() != "":
		_texture_context.dispose_texture(self, texture_cache_name)
	_texture_context = null


func _update_sprite() -> void:
	var cache_name := texture_cache_name.strip_edges()
	if cache_name == "":
		return

	_ensure_cache(cache_name)
	var next_context = _build_context()
	if next_context.invalid:
		return

	if _texture_context != null and _texture_context.final_key != next_context.final_key:
		_texture_context.dispose_texture(self, cache_name)

	_texture_context = next_context
	texture = _texture_context.get_texture(self, cache_name)
	hframes = 1
	vframes = 1
	frame = 0
	frame_coords = Vector2i.ZERO
	region_enabled = false
	region_rect = Rect2i(Vector2i.ZERO, _TEXTURE_SIZE)
	region_filter_clip_enabled = false
	offset = Vector2i(0, -_TEXTURE_SIZE.y)
	centered = false
