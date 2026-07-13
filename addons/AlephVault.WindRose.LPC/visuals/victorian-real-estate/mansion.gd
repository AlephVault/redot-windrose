@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianRealEstate.Base


const _Core := preload("./mansion_parts/core.gd")
const _TEXTURE_REFRESH_DEBOUNCE_SECONDS := 0.05
const _TEXTURE_BUILD_STEPS_PER_FRAME := 1


static var _cache_ensured: bool = false


var _texture_context = null
var _texture_refresh_generation: int = 0


@export var use_bricked_prongs: bool = false:
	set(value):
		_log_property_update_started("use_bricked_prongs", use_bricked_prongs, value)
		_release_texture()
		use_bricked_prongs = value
		_refresh_texture()
		_log_property_update_finished("use_bricked_prongs", use_bricked_prongs)


@export var first_floor_prongs: _Core.FirstFloorProngs = _Core.FirstFloorProngs.REGULAR_WINDOWS:
	set(value):
		_log_property_update_started("first_floor_prongs", first_floor_prongs, value)
		_release_texture()
		first_floor_prongs = value
		_refresh_texture()
		_log_property_update_finished("first_floor_prongs", first_floor_prongs)


@export var prong_window_color: _Core.WindowColor = _Core.WindowColor.CLASSIC:
	set(value):
		_log_property_update_started("prong_window_color", prong_window_color, value)
		_release_texture()
		prong_window_color = value
		_refresh_texture()
		_log_property_update_finished("prong_window_color", prong_window_color)


@export var prong_window_index: int = 0:
	set(value):
		_log_property_update_started("prong_window_index", prong_window_index, value)
		_release_texture()
		prong_window_index = value
		_refresh_texture()
		_log_property_update_finished("prong_window_index", prong_window_index)


@export var non_prong_window_color: _Core.WindowColor = _Core.WindowColor.CLASSIC:
	set(value):
		_log_property_update_started("non_prong_window_color", non_prong_window_color, value)
		_release_texture()
		non_prong_window_color = value
		_refresh_texture()
		_log_property_update_finished("non_prong_window_color", non_prong_window_color)


@export var non_prong_window_index: int = 0:
	set(value):
		_log_property_update_started("non_prong_window_index", non_prong_window_index, value)
		_release_texture()
		non_prong_window_index = value
		_refresh_texture()
		_log_property_update_finished("non_prong_window_index", non_prong_window_index)


@export var roof_color: _Core.RoofColor = _Core.RoofColor.PURPLE:
	set(value):
		_log_property_update_started("roof_color", roof_color, value)
		_release_texture()
		roof_color = value
		_refresh_texture()
		_log_property_update_finished("roof_color", roof_color)


@export var wall_color: _Core.WallColor = _Core.WallColor.YELLOW:
	set(value):
		_log_property_update_started("wall_color", wall_color, value)
		_release_texture()
		wall_color = value
		_refresh_texture()
		_log_property_update_finished("wall_color", wall_color)


@export var light_mode: _Core.LightMode = _Core.LightMode.DAY:
	set(value):
		_log_property_update_started("light_mode", light_mode, value)
		_release_texture()
		light_mode = value
		_refresh_texture()
		_log_property_update_finished("light_mode", light_mode)


@export var door_shape: _Core.DoorShape = _Core.DoorShape.RECTANGULAR:
	set(value):
		_log_property_update_started("door_shape", door_shape, value)
		_release_texture()
		door_shape = value
		_refresh_texture()
		_log_property_update_finished("door_shape", door_shape)


@export var door_index: int = 0:
	set(value):
		_log_property_update_started("door_index", door_index, value)
		_release_texture()
		door_index = value
		_refresh_texture()
		_log_property_update_finished("door_index", door_index)


@export var is_door_open: bool = false:
	set(value):
		_log_property_update_started("is_door_open", is_door_open, value)
		_release_texture()
		is_door_open = value
		_refresh_texture()
		_log_property_update_finished("is_door_open", is_door_open)


@export var has_doorframe: bool = false:
	set(value):
		_log_property_update_started("has_doorframe", has_doorframe, value)
		_release_texture()
		has_doorframe = value
		_refresh_texture()
		_log_property_update_finished("has_doorframe", has_doorframe)


@export var doorframe_color: _Core.DoorframeColor = _Core.DoorframeColor.ORANGE_LIGHT:
	set(value):
		_log_property_update_started("doorframe_color", doorframe_color, value)
		_release_texture()
		doorframe_color = value
		_refresh_texture()
		_log_property_update_finished("doorframe_color", doorframe_color)


@export var doorframe_index: int = 0:
	set(value):
		_log_property_update_started("doorframe_index", doorframe_index, value)
		_release_texture()
		doorframe_index = value
		_refresh_texture()
		_log_property_update_finished("doorframe_index", doorframe_index)


@export var doorsteps_color: _Core.DoorstepsColor = _Core.DoorstepsColor.GRAY_LIGHT:
	set(value):
		_log_property_update_started("doorsteps_color", doorsteps_color, value)
		_release_texture()
		doorsteps_color = value
		_refresh_texture()
		_log_property_update_finished("doorsteps_color", doorsteps_color)


@export var stories: _Core.Stories = _Core.Stories.SINGLE:
	set(value):
		_log_property_update_started("stories", stories, value)
		_release_texture()
		stories = value
		_refresh_texture()
		_log_property_update_finished("stories", stories)


@export var depth: _Core.Depth = _Core.Depth.SINGLE:
	set(value):
		_log_property_update_started("depth", depth, value)
		_release_texture()
		depth = value
		_refresh_texture()
		_log_property_update_finished("depth", depth)


@export var design: _Core.Design = _Core.Design.LINE_SHAPE:
	set(value):
		_log_property_update_started("design", design, value)
		_release_texture()
		design = value
		_refresh_texture()
		_log_property_update_finished("design", design)


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
	pass


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


func _log_property_update_started(property_name: String, old_value, new_value) -> void:
	print(
		"Mansion: updating %s from %s to %s; regenerating image" %
		[property_name, str(old_value), str(new_value)]
	)


func _log_property_update_finished(property_name: String, value) -> void:
	print(
		"Mansion: updated %s to %s; image regenerated (%s)" %
		[property_name, str(value), _texture_status()]
	)


func _texture_status() -> String:
	if _texture_context == null:
		return "no texture context"
	if texture == null:
		return "no texture"
	return "%dx%d" % [_texture_context.width, _texture_context.height]


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
		door_index,
		is_door_open,
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
	_texture_refresh_generation += 1
	if _texture_context != null and _cache_ensured:
		_texture_context.dispose_texture(self, TEXTURE_CACHE_KEY)
	_texture_context = null


func _refresh_texture() -> void:
	_texture_refresh_generation += 1
	var generation := _texture_refresh_generation
	if is_inside_tree():
		_refresh_texture_debounced(generation)
	else:
		_refresh_texture_now(generation, false)


func _refresh_texture_debounced(generation: int) -> void:
	await get_tree().create_timer(_TEXTURE_REFRESH_DEBOUNCE_SECONDS).timeout
	if generation != _texture_refresh_generation:
		return
	await _refresh_texture_now(generation, true)


func _refresh_texture_now(generation: int, chunked: bool) -> void:
	_ensure_cache()
	var next_context = _build_context()
	if next_context.invalid:
		return
	if generation != _texture_refresh_generation:
		return

	var size: Vector2i = Vector2i(next_context.width, next_context.height)
	var previous_context = _texture_context
	var next_texture: Texture2D
	if chunked:
		next_texture = await next_context.get_texture_chunked(
			self, TEXTURE_CACHE_KEY, _TEXTURE_BUILD_STEPS_PER_FRAME
		)
	else:
		next_texture = next_context.get_texture(self, TEXTURE_CACHE_KEY)
	if generation != _texture_refresh_generation:
		return
	if previous_context != null and previous_context.final_key != next_context.final_key:
		previous_context.dispose_texture(self, TEXTURE_CACHE_KEY)
	_texture_context = next_context
	texture = next_texture
	hframes = 1
	vframes = 1
	frame = 0
	frame_coords = Vector2i.ZERO
	region_enabled = false
	region_rect = Rect2i(Vector2i.ZERO, size)
	region_filter_clip_enabled = false
	offset = _Core.compute_offset(stories)
	centered = false
