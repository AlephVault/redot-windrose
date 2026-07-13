extends RefCounted
## A texture composition step describes a source texture
## region and the target position where that region must
## be alpha-blended into a final image.

const _FORMAT: Image.Format = Image.FORMAT_RGBA8
const _LRURegistry = preload("../lru/registry.gd")
const _SOURCE_IMAGE_CACHE_KEY := "AlephVault.WindRose:source-texture-images"
const _SOURCE_IMAGE_CACHE_MAX_DISPOSAL_SIZE := 16

static var _source_image_cache_ensured: bool = false

var _key: String
var _texture: Texture2D
var _source_rect: Rect2i
var _target_position: Vector2i
var _invalid: bool

## The unique key of this step.
var key: String:
	get:
		return _key
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Step", "key"
		)

## The source texture used by this step.
var texture: Texture2D:
	get:
		return _texture
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Step", "texture"
		)

## The region to read from the source texture.
var source_rect: Rect2i:
	get:
		return _source_rect
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Step", "source_rect"
		)

## The top-left position in the target image where the
## source rectangle will be blended.
var target_position: Vector2i:
	get:
		return _target_position
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Step", "target_position"
		)

## The target rectangle implied by the target position
## and the source rectangle size.
var target_rect: Rect2i:
	get:
		return Rect2i(_target_position, _source_rect.size)
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Step", "target_rect"
		)

## Whether the step arguments are invalid according to
## the same rules enforced by the constructor asserts.
var invalid: bool:
	get:
		return _invalid
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Step", "invalid"
		)

## Builds a composition step after validating:
## - non-empty key
## - non-negative source origin
## - strictly positive source size
## - source rect fully inside the source texture
## - non-negative target position
## - RGBA8 source texture image data
func _init(
	step_key: String,
	step_texture: Texture2D,
	step_source_rect: Rect2i,
	step_target_position: Vector2i
):
	_key = step_key
	_texture = step_texture
	_source_rect = step_source_rect
	_target_position = step_target_position

	var present_key: bool = step_key != ""
	var present_texture: bool = step_texture != null
	var non_negative_sr_start: bool = step_source_rect.position.x >= 0 and step_source_rect.position.y >= 0
	var positive_sr_size: bool = step_source_rect.size.x > 0 and step_source_rect.size.y > 0
	var non_negative_tr_start: bool = step_target_position.x >= 0 and step_target_position.y >= 0
	_invalid = not (
		present_key and present_texture and non_negative_sr_start and
		positive_sr_size and non_negative_tr_start
	)

	assert(present_key, "The step key must not be empty")
	assert(present_texture, "The step texture must be a valid Texture2D")
	assert(non_negative_sr_start, "The source rect position must be non-negative")
	assert(positive_sr_size, "The source rect size must be strictly positive")
	assert(non_negative_tr_start, "The target position must be non-negative")

	var width: int = step_texture.get_width()
	var height: int = step_texture.get_height()
	var valid_sr_end: bool = step_source_rect.end.x <= width and step_source_rect.end.y <= height
	_invalid = _invalid or not valid_sr_end
	assert(
		valid_sr_end,
		"The source rect must be completely contained in the texture dimensions"
	)

	var image: Image = get_cached_source_image(step_texture, self)
	var present_image: bool = image != null
	var valid_format: bool = present_image and image.get_format() == _FORMAT
	_invalid = _invalid or not valid_format
	assert(present_image, "The step texture must expose image data")
	assert(valid_format, "The step texture must use RGBA8 format")
	release_cached_source_image(step_texture, self)

## Alpha-blends this step source rectangle into the
## given target image at the configured target position.
func blend_into(target_image: Image):
	assert(not invalid, "This step is invalid. It cannot be processed")
	assert(target_image != null, "A valid target image is required")
	if invalid or target_image == null:
		return

	var source_image: Image = get_cached_source_image(_texture, self)
	assert(source_image != null, "The step texture must expose image data")
	if source_image == null:
		return
	var valid_format: bool = source_image.get_format() == _FORMAT
	assert(valid_format, "The step texture must use RGBA8 format")
	if valid_format:
		target_image.blend_rect(source_image, _source_rect, _target_position)
	release_cached_source_image(_texture, self)


static func get_cached_source_image(texture: Texture2D, owner: Object) -> Image:
	_ensure_source_image_cache()
	var cache = _LRURegistry.fetch(_SOURCE_IMAGE_CACHE_KEY)
	if cache == null:
		return texture.get_image()

	var entry_key := _source_image_entry_key(texture)
	var get_response = cache.get_value(entry_key, owner)
	if get_response.is_successful():
		var cached_image: Image = get_response.value
		if cached_image != null:
			return cached_image

	var image: Image = texture.get_image()
	if image == null:
		return null
	var set_response = cache.set_value(entry_key, image, null, owner)
	return set_response.value


static func release_cached_source_image(texture: Texture2D, owner: Object) -> void:
	_ensure_source_image_cache()
	var cache = _LRURegistry.fetch(_SOURCE_IMAGE_CACHE_KEY)
	if cache != null:
		cache.delete_value(_source_image_entry_key(texture), owner)


static func _ensure_source_image_cache() -> void:
	if _source_image_cache_ensured:
		return
	if not _LRURegistry.has(_SOURCE_IMAGE_CACHE_KEY):
		_LRURegistry.define(_SOURCE_IMAGE_CACHE_KEY, _SOURCE_IMAGE_CACHE_MAX_DISPOSAL_SIZE)
	_source_image_cache_ensured = true


static func _source_image_entry_key(texture: Texture2D) -> String:
	return str(texture.get_instance_id())
