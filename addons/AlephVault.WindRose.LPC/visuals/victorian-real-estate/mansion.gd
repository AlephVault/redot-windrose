@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianRealEstate.Base


const _Core := preload("./mansion_parts/core.gd")


static var _cache_ensured: bool = false


var _texture_context = null


@export var use_bricked_prongs: bool = false:
	set(value):
		_release_texture()
		use_bricked_prongs = value
		_refresh_texture()


@export var first_floor_prongs: _Core.FirstFloorProngs = _Core.FirstFloorProngs.REGULAR_WINDOWS:
	set(value):
		_release_texture()
		first_floor_prongs = value
		_refresh_texture()


@export var prong_window_color: _Core.WindowColor = _Core.WindowColor.CLASSIC:
	set(value):
		_release_texture()
		prong_window_color = value
		_refresh_texture()


@export var prong_window_index: int = 0:
	set(value):
		_release_texture()
		prong_window_index = value
		_refresh_texture()


@export var non_prong_window_color: _Core.WindowColor = _Core.WindowColor.CLASSIC:
	set(value):
		_release_texture()
		non_prong_window_color = value
		_refresh_texture()


@export var non_prong_window_index: int = 0:
	set(value):
		_release_texture()
		non_prong_window_index = value
		_refresh_texture()


@export var roof_color: _Core.RoofColor = _Core.RoofColor.PURPLE:
	set(value):
		_release_texture()
		roof_color = value
		_refresh_texture()


@export var wall_color: _Core.WallColor = _Core.WallColor.YELLOW:
	set(value):
		_release_texture()
		wall_color = value
		_refresh_texture()


@export var light_mode: _Core.LightMode = _Core.LightMode.DAY:
	set(value):
		_release_texture()
		light_mode = value
		_refresh_texture()


@export var door_shape: _Core.DoorShape = _Core.DoorShape.RECTANGULAR:
	set(value):
		_release_texture()
		door_shape = value
		_refresh_texture()


@export var has_doorframe: bool = false:
	set(value):
		_release_texture()
		has_doorframe = value
		_refresh_texture()


@export var doorframe_color: _Core.DoorframeColor = _Core.DoorframeColor.ORANGE_LIGHT:
	set(value):
		_release_texture()
		doorframe_color = value
		_refresh_texture()


@export var doorframe_index: int = 0:
	set(value):
		_release_texture()
		doorframe_index = value
		_refresh_texture()


@export var doorsteps_color: _Core.DoorstepsColor = _Core.DoorstepsColor.GRAY_LIGHT:
	set(value):
		_release_texture()
		doorsteps_color = value
		_refresh_texture()


@export var stories: _Core.Stories = _Core.Stories.SINGLE:
	set(value):
		_release_texture()
		stories = value
		_refresh_texture()


@export var depth: _Core.Depth = _Core.Depth.SINGLE:
	set(value):
		_release_texture()
		depth = value
		_refresh_texture()


@export var design: _Core.Design = _Core.Design.LINE_SHAPE:
	set(value):
		_release_texture()
		design = value
		_refresh_texture()


func _init() -> void:
	_refresh_texture()


func _ready() -> void:
	_refresh_texture()


func _setup():
	_refresh_texture()


func _teardown():
	_release_texture()


func _pause():
	pass


func _resume():
	pass


func _update(_delta: float):
	_refresh_texture()


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


static func _ensure_cache() -> void:
	if _cache_ensured:
		return
	if not AlephVault__WindRose.Utils.LRU.Registry.has(TEXTURE_CACHE_KEY):
		AlephVault__WindRose.Utils.LRU.Registry.define(
			TEXTURE_CACHE_KEY, _DEFAULT_CACHE_MAX_DISPOSAL_SIZE
		)
	_cache_ensured = true


func _build_context():
	var size: Vector2i = _Core.compute_size(stories, depth, design)
	var steps: Array[_Step] = _Core.make_mansion_steps(
		use_bricked_prongs,
		first_floor_prongs,
		prong_window_color,
		prong_window_index,
		non_prong_window_color,
		non_prong_window_index,
		roof_color,
		wall_color,
		light_mode,
		door_shape,
		has_doorframe,
		doorframe_color,
		doorframe_index,
		doorsteps_color,
		stories,
		depth,
		design
	)
	return _Context.new(size.x, size.y, steps)


func _release_texture() -> void:
	if _texture_context != null and _cache_ensured:
		_texture_context.dispose_texture(self, TEXTURE_CACHE_KEY)
	_texture_context = null


func _refresh_texture() -> void:
	_ensure_cache()
	var next_context = _build_context()
	if next_context.invalid:
		return

	if _texture_context != null and _texture_context.final_key != next_context.final_key:
		_texture_context.dispose_texture(self, TEXTURE_CACHE_KEY)

	var size: Vector2i = Vector2i(next_context.width, next_context.height)
	_texture_context = next_context
	texture = _texture_context.get_texture(self, TEXTURE_CACHE_KEY)
	hframes = 1
	vframes = 1
	frame = 0
	frame_coords = Vector2i.ZERO
	region_enabled = false
	region_rect = Rect2i(Vector2i.ZERO, size)
	region_filter_clip_enabled = false
	offset = _Core.compute_offset(stories)
	centered = false
