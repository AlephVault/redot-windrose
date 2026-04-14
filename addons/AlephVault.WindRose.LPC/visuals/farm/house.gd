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


## The brick color used by the house body parts.
enum BrickColor {
	LIGHT_BLUE = 0,
	LIGHT_GRAY = 1,
	GRAY = 2,
	LIGHT_BROWN = 3,
	BROWN = 4,
	RED = 5,
}


## The color of the door. Please note that is
## is different to the color of the doorframes.
enum DoorColor {
	RED = 0,
	YELLOW = 1,
	GREEN = 2,
	BLUE = 3,
	WHITE = 4,
	MID_WHITE = 5,
	MID_DARK = 6,
	DARK = 7,
	BROWN1_LIGHT = 8,
	BROWN1_MID_LIGHT = 9,
	BROWN1_MID_DARK = 10,
	BROWN1_DARK = 11,
	BROWN2_LIGHT = 12,
	BROWN2_MID_LIGHT = 13,
	BROWN2_MID_DARK = 14,
	BROWN2_DARK = 15
}


## The color of the doorframe. Please note that it
## is different to the color of the door.
enum DoorframeColor {
	ORANGE_LIGHT = 0,
	ORANGE_MID = 1,
	ORANGE_DARK = 2,
	BROWN_LIGHT = 3,
	BROWN_MID = 4,
	BROWN_DARK = 5,
	GRAY_LIGHT = 6,
	GRAY_MID = 7,
	GRAY_DARK = 8,
	BLUE_LIGHT = 9,
	BLUE_MID = 10,
	BLUE_DARK = 11
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


## Whether the door has windows or not.
@export var doorframe_color: DoorframeColor = DoorframeColor.ORANGE_LIGHT:
	set(value):
		if doorframe_color == value:
			return
		_release_texture()
		doorframe_color = value
		_update_sprite()


## Whether the door has windows or not.
@export var has_doorframe: bool = true:
	set(value):
		if has_doorframe == value:
			return
		_release_texture()
		has_doorframe = value
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
