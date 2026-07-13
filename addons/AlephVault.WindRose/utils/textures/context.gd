extends RefCounted
## A texture composition context defines the target size
## and the ordered steps that will be blended to build
## a final cached texture.

const _FORMAT: Image.Format = Image.FORMAT_RGBA8
const _Step = preload("./step.gd")
const _LRURegistry = preload("../lru/registry.gd")

var _width: int
var _height: int
var _steps: Array
var _final_key: String
var _invalid: bool

## The target texture width.
var width: int:
	get:
		return _width
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Context", "width"
		)

## The target texture height.
var height: int:
	get:
		return _height
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Context", "height"
		)

## The ordered list of composition steps.
var steps: Array:
	get:
		return _steps.duplicate()
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Context", "steps"
		)

## The cache key derived from all the step keys.
var final_key: String:
	get:
		return _final_key
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Context", "final_key"
		)

## Whether the context arguments are invalid according to
## the same rules enforced by the constructor asserts.
var invalid: bool:
	get:
		return _invalid
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"Context", "invalid"
		)

## Builds a context after validating:
## - strictly positive target dimensions
## - non-null steps array
## - each element is a Step
## - each step itself is valid
## - every step target rect is fully contained in bounds
func _init(texture_width: int, texture_height: int, texture_steps: Array):
	_width = texture_width
	_height = texture_height
	_steps = []
	_invalid = false

	var step_keys: Array[String] = []
	var bounds := Rect2i(Vector2i.ZERO, Vector2i(_width, _height))
	var valid_dimensions: bool = texture_width > 0 and texture_height > 0
	var present_steps: bool = texture_steps != null
	_invalid = not (valid_dimensions and present_steps)

	assert(
		valid_dimensions,
		"The target texture dimensions must be strictly positive"
	)
	assert(present_steps, "The steps array must not be null")

	for step in texture_steps:
		var valid_step_type: bool = step is _Step
		_invalid = _invalid or not valid_step_type
		assert(
			valid_step_type,
			"Each step must be an AlephVault__WindRose.Utils.Textures.Step"
		)
		if not valid_step_type:
			continue

		var valid_step: bool = not step.invalid
		_invalid = _invalid or not valid_step
		assert(valid_step, "Each step must be valid, but step '" + step.key + "' is not")
		if not valid_step:
			continue

		var enclosed_target: bool = bounds.encloses(step.target_rect)
		_invalid = _invalid or not enclosed_target
		assert(
			enclosed_target,
			"Each target rect must be fully contained in the target texture"
		)
		if not enclosed_target:
			continue

		_steps.push_back(step)
		step_keys.push_back(step.key)

	_final_key = ":".join(step_keys)

## Builds the final texture by alpha-blending all the
## configured steps over a transparent RGBA8 image.
func _build_texture() -> Texture2D:
	assert(not invalid, "This context is invalid. It cannot be processed")
	if invalid:
		return null

	var image := Image.create_empty(_width, _height, false, _FORMAT)
	image.fill(Color(0, 0, 0, 0))
	var source_images := {}
	for step in _steps:
		_blend_step_into(image, step, source_images)
	var texture := ImageTexture.create_from_image(image)
	_release_step_source_images(source_images)
	return texture

## Builds the final texture like `_build_texture`, but yields every
## `steps_per_frame` steps so large compositions do not monopolize a frame.
func _build_texture_chunked(obj, steps_per_frame: int = 8) -> Texture2D:
	assert(not invalid, "This context is invalid. It cannot be processed")
	if invalid:
		return null

	var image := Image.create_empty(_width, _height, false, _FORMAT)
	image.fill(Color(0, 0, 0, 0))
	var source_images := {}
	var effective_steps_per_frame: int = maxi(1, steps_per_frame)
	var steps_since_yield: int = 0
	for step in _steps:
		_blend_step_into(image, step, source_images)
		steps_since_yield += 1
		if steps_since_yield >= effective_steps_per_frame:
			steps_since_yield = 0
			if obj is Node and is_instance_valid(obj) and obj.is_inside_tree():
				await obj.get_tree().process_frame
	if obj is Node and is_instance_valid(obj) and obj.is_inside_tree():
		await obj.get_tree().process_frame
	var texture := ImageTexture.create_from_image(image)
	_release_step_source_images(source_images)
	return texture

func _blend_step_into(target_image: Image, step: _Step, source_images: Dictionary) -> void:
	assert(not step.invalid, "This step is invalid. It cannot be processed")
	assert(target_image != null, "A valid target image is required")
	if step.invalid or target_image == null:
		return

	var source_image: Image = _get_step_source_image(step, source_images)
	assert(source_image != null, "The step texture must expose image data")
	if source_image == null:
		return
	var valid_format: bool = source_image.get_format() == _FORMAT
	assert(valid_format, "The step texture must use RGBA8 format")
	if not valid_format:
		return
	target_image.blend_rect(source_image, step.source_rect, step.target_position)

func _get_step_source_image(step: _Step, source_images: Dictionary) -> Image:
	var texture_id: int = step.texture.get_instance_id()
	if not source_images.has(texture_id):
		source_images[texture_id] = {
			"texture": step.texture,
			"image": _Step.get_cached_source_image(step.texture, self),
		}
	return source_images[texture_id]["image"]


func _release_step_source_images(source_images: Dictionary) -> void:
	for texture_id in source_images:
		var record: Dictionary = source_images[texture_id]
		_Step.release_cached_source_image(record["texture"], self)

## Gets an already cached texture for this context or
## builds and stores it in the configured LRU cache.
func get_texture(obj, cache_key: String) -> Texture2D:
	assert(not invalid, "This context is invalid. It cannot be processed")
	if invalid:
		return null

	var cache = _LRURegistry.fetch(cache_key)
	if cache == null:
		return null

	var get_response = cache.get_value(_final_key, obj)
	if get_response.is_successful():
		var cached_texture: Texture2D = get_response.value
		if cached_texture != null:
			return cached_texture

	var built_texture: Texture2D = _build_texture()
	var set_response = cache.set_value(_final_key, built_texture, null, obj)
	return set_response.value

## Gets a cached texture or builds it across multiple frames.
func get_texture_chunked(obj, cache_key: String, steps_per_frame: int = 8) -> Texture2D:
	assert(not invalid, "This context is invalid. It cannot be processed")
	if invalid:
		return null

	var cache = _LRURegistry.fetch(cache_key)
	if cache == null:
		return null

	var get_response = cache.get_value(_final_key, obj)
	if get_response.is_successful():
		var cached_texture: Texture2D = get_response.value
		if cached_texture != null:
			return cached_texture

	var built_texture: Texture2D = await _build_texture_chunked(obj, steps_per_frame)
	var set_response = cache.set_value(_final_key, built_texture, null, obj)
	return set_response.value

## Removes the caller reference for this context final key
## from the configured LRU cache.
func dispose_texture(obj, cache_key: String):
	assert(not invalid, "This context is invalid. It cannot be processed")
	if invalid:
		return

	var cache = _LRURegistry.fetch(cache_key)
	if cache == null:
		return

	cache.delete_value(_final_key, obj)
