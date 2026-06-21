@tool
extends AlephVault__WindRose.Maps.Visuals.StaticMapEntityVisual


const _Step := AlephVault__WindRose.Utils.Textures.Step
const _Context := AlephVault__WindRose.Utils.Textures.Context

const TEXTURE_CACHE_KEY := "AlephVault.WindRose.LPC:wooden-furniture"
const _DEFAULT_CACHE_MAX_DISPOSAL_SIZE := 128

const _DARK_WOOD_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/wooden-furniture/dark-wood.png")
const _BLONDE_WOOD_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/wooden-furniture/blonde-wood.png")
const _GREEN_WOOD_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/wooden-furniture/green-wood.png")
const _WHITE_WOOD_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/wooden-furniture/white-wood.png")


## The wooden furniture tone to render.
enum Tone {
	DARK,
	BLONDE,
	GREEN,
	WHITE,
}


const _TONE_TEXTURES := {
	Tone.DARK: _DARK_WOOD_TEXTURE,
	Tone.BLONDE: _BLONDE_WOOD_TEXTURE,
	Tone.GREEN: _GREEN_WOOD_TEXTURE,
	Tone.WHITE: _WHITE_WOOD_TEXTURE,
}


## Maximum disposal queue size for composed wooden furniture
## textures. Set this during application startup, before the
## first composed wooden furniture visual refreshes.
static var texture_cache_max_disposal_size: int = _DEFAULT_CACHE_MAX_DISPOSAL_SIZE
static var _cache_ensured: bool = false
static var _locked_texture_cache_max_disposal_size: int = 0


## The wood tone used by this visual.
@export var tone: Tone = Tone.DARK:
	set(value):
		if tone == value:
			return
		_release_texture()
		tone = value
		_setup_sprite()


var _texture_context = null


func _init() -> void:
	_setup_sprite()


func _ready() -> void:
	_setup_sprite()


func _setup() -> void:
	_setup_sprite()
	super._setup()


func _teardown() -> void:
	_release_texture()
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


func _make_frameset_setup(rect: Rect2i) -> FramesetSetup:
	return FramesetSetup.new(
		texture,
		rect,
		_get_frame_count(),
		_is_vertically_distributed(),
		centered,
		offset
	)


func _make_full_setup() -> FullSetup:
	var down_rect := _get_region_rect()
	var up_rect := _get_region_rect_up()
	var left_rect := _get_region_rect_left()
	var right_rect := _get_region_rect_right()
	var has_directional_regions := _is_valid_region_rect(up_rect) or \
			_is_valid_region_rect(left_rect) or _is_valid_region_rect(right_rect)

	if has_directional_regions:
		return FullSetup.new(
			StateSetup.new(
				_make_frameset_setup(down_rect),
				_make_frameset_setup(up_rect if _is_valid_region_rect(up_rect) else down_rect),
				_make_frameset_setup(left_rect if _is_valid_region_rect(left_rect) else down_rect),
				_make_frameset_setup(right_rect if _is_valid_region_rect(right_rect) else down_rect)
			)
		)

	return FullSetup.new(StateSetup.new(_make_frameset_setup(down_rect)))


static func _ensure_cache() -> void:
	assert(texture_cache_max_disposal_size >= 0, "The wooden furniture texture cache disposal size must be non-negative")
	if _cache_ensured:
		assert(
			texture_cache_max_disposal_size == _locked_texture_cache_max_disposal_size,
			"The wooden furniture texture cache disposal size cannot change after the cache is ensured"
		)
	else:
		_locked_texture_cache_max_disposal_size = texture_cache_max_disposal_size
		_cache_ensured = true
	if not AlephVault__WindRose.Utils.LRU.Registry.has(TEXTURE_CACHE_KEY):
		AlephVault__WindRose.Utils.LRU.Registry.define(
			TEXTURE_CACHE_KEY, _locked_texture_cache_max_disposal_size
		)


func _get_tone_texture(wood_tone: int = -1) -> Texture2D:
	var effective_tone := tone if wood_tone < 0 else wood_tone
	return _TONE_TEXTURES.get(effective_tone, _TONE_TEXTURES[Tone.DARK])


func _make_step(
	part: String,
	source_rect: Rect2i,
	target_position: Vector2i = Vector2i.ZERO,
	wood_tone: int = -1
) -> Object:
	return _Step.new(part, _get_tone_texture(wood_tone), source_rect, target_position)


func _make_context(texture_size: Vector2i, steps: Array) -> Object:
	return _Context.new(texture_size.x, texture_size.y, steps)


func _get_texture_context():
	return null


func _get_region_rect() -> Rect2i:
	var tone_texture := _get_tone_texture()
	return Rect2i(Vector2i.ZERO, Vector2i(tone_texture.get_size()))


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


func _release_texture() -> void:
	if _texture_context != null and _cache_ensured:
		_texture_context.dispose_texture(self, TEXTURE_CACHE_KEY)
	_texture_context = null


func _setup_sprite() -> void:
	var next_texture := _get_tone_texture()
	var next_context = _get_texture_context()

	if next_context != null:
		_ensure_cache()
		if next_context.invalid:
			return
		if _texture_context != null and _texture_context.final_key != next_context.final_key:
			_texture_context.dispose_texture(self, TEXTURE_CACHE_KEY)
		_texture_context = next_context
		next_texture = _texture_context.get_texture(self, TEXTURE_CACHE_KEY)
	elif _texture_context != null:
		_release_texture()

	if next_texture == null:
		return

	texture = next_texture
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
		full_setup.default_state.set_image(texture)
		_apply()
