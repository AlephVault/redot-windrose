@tool
extends AlephVault__WindRose.Maps.Visuals.StaticMapEntityVisual


const _Step := AlephVault__WindRose.Utils.Textures.Step
const _Context := AlephVault__WindRose.Utils.Textures.Context

const TEXTURE_CACHE_KEY := "AlephVault.WindRose.LPC:victorian-street-appliances"
const _DEFAULT_CACHE_MAX_DISPOSAL_SIZE := 128

const _SOURCE_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/victorian-decoration/street-appliances.png")


## Maximum disposal queue size for composed Victorian street appliance
## textures. Set this during application startup, before the first
## composed appliance visual refreshes.
static var texture_cache_max_disposal_size: int = _DEFAULT_CACHE_MAX_DISPOSAL_SIZE
static var _cache_ensured: bool = false
static var _locked_texture_cache_max_disposal_size: int = 0


var _texture_contexts: Array = []
var _cached_textures: Array[Texture2D] = []


func _init() -> void:
	_setup_sprite()


func _ready() -> void:
	_setup_sprite()


func _setup() -> void:
	_setup_sprite()
	super._setup()


func _teardown() -> void:
	_release_textures()
	super._teardown()


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
		"_vertically_distributed",
		"_region_rect_up",
		"_region_rect_left",
		"_region_rect_right",
	]:
		property.usage = PROPERTY_USAGE_NO_EDITOR


func _is_valid_region_rect(rect: Rect2i) -> bool:
	return rect.position.x >= 0 and rect.position.y >= 0 and \
		   rect.size.x > 0 and rect.size.y > 0


func _contexts_changed(next_contexts: Array) -> bool:
	if _texture_contexts.size() != next_contexts.size():
		return true
	for index in next_contexts.size():
		var current_context = _texture_contexts[index]
		var next_context = next_contexts[index]
		if current_context == null or next_context == null:
			if current_context != next_context:
				return true
		elif current_context.final_key != next_context.final_key:
			return true
	return false


func _make_frameset_setup(
	rect: Rect2i,
	frame_count: int = -1,
	image: Texture2D = null
) -> FramesetSetup:
	return FramesetSetup.new(
		texture if image == null else image,
		rect,
		_get_frame_count() if frame_count < 0 else frame_count,
		_is_vertically_distributed(),
		centered,
		offset
	)


func _make_full_setup() -> FullSetup:
	return FullSetup.new(StateSetup.new(_make_frameset_setup(_get_region_rect())))


static func _ensure_cache() -> void:
	assert(texture_cache_max_disposal_size >= 0, "The Victorian street appliance texture cache disposal size must be non-negative")
	if _cache_ensured:
		assert(
			texture_cache_max_disposal_size == _locked_texture_cache_max_disposal_size,
			"The Victorian street appliance texture cache disposal size cannot change after the cache is ensured"
		)
	else:
		_locked_texture_cache_max_disposal_size = texture_cache_max_disposal_size
		_cache_ensured = true
	if not AlephVault__WindRose.Utils.LRU.Registry.has(TEXTURE_CACHE_KEY):
		AlephVault__WindRose.Utils.LRU.Registry.define(
			TEXTURE_CACHE_KEY, _locked_texture_cache_max_disposal_size
		)


func _make_step(
	part: String,
	source_rect: Rect2i,
	target_position: Vector2i = Vector2i.ZERO
) -> Object:
	return _Step.new(part, _SOURCE_TEXTURE, source_rect, target_position)


func _make_context(texture_size: Vector2i, steps: Array) -> Object:
	return _Context.new(texture_size.x, texture_size.y, steps)


func _get_texture_context():
	return null


func _get_texture_contexts() -> Array:
	var context = _get_texture_context()
	return [] if context == null else [context]


func _get_cached_texture(index: int) -> Texture2D:
	if index < 0 or index >= _cached_textures.size():
		return null
	return _cached_textures[index]


func _get_region_rect() -> Rect2i:
	return Rect2i(Vector2i.ZERO, Vector2i(_SOURCE_TEXTURE.get_size()))


func _get_region_rect_up() -> Rect2i:
	return Rect2i()


func _get_region_rect_left() -> Rect2i:
	return Rect2i()


func _get_region_rect_right() -> Rect2i:
	return Rect2i()


func _get_frame_count() -> int:
	return 1


func _is_vertically_distributed() -> bool:
	return true


func _get_offset() -> Vector2:
	return Vector2(0, -_get_region_rect().size.y)


func _release_textures() -> void:
	if _cache_ensured:
		for context in _texture_contexts:
			if context != null:
				context.dispose_texture(self, TEXTURE_CACHE_KEY)
	_texture_contexts = []
	_cached_textures = []


func _setup_sprite() -> void:
	var next_contexts = _get_texture_contexts()
	var next_texture: Texture2D = _SOURCE_TEXTURE

	if not next_contexts.is_empty():
		_ensure_cache()
		for context in next_contexts:
			if context == null or context.invalid:
				return
		if _contexts_changed(next_contexts):
			_release_textures()
		_texture_contexts = next_contexts
		_cached_textures = []
		for context in _texture_contexts:
			_cached_textures.push_back(context.get_texture(self, TEXTURE_CACHE_KEY))
		next_texture = _cached_textures[0]
	elif not _texture_contexts.is_empty():
		_release_textures()

	if next_texture == null:
		return

	texture = next_texture
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED
	region_enabled = true
	region_filter_clip_enabled = true
	region_rect = _get_region_rect()
	_region_rect_up = _get_region_rect_up()
	_region_rect_left = _get_region_rect_left()
	_region_rect_right = _get_region_rect_right()
	_vertically_distributed = _is_vertically_distributed()
	if _vertically_distributed:
		hframes = 1
		vframes = _get_frame_count()
	else:
		hframes = _get_frame_count()
		vframes = 1
	frame = 0
	frame_coords = Vector2i.ZERO
	centered = false
	offset = _get_offset()

	if is_instance_valid(full_setup):
		full_setup = _make_full_setup()
		_apply()
