extends Object
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
	for step in _steps:
		step.blend_into(image)
	return ImageTexture.create_from_image(image)

## Gets an already cached texture for this context or
## builds and stores it in the configured LRU cache.
func get(obj, cache_key: String) -> Texture2D:
	assert(not invalid, "This context is invalid. It cannot be processed")
	if invalid:
		return null

	var cache = _LRURegistry.fetch(cache_key)
	if cache == null:
		return null

	var get_response = cache.get(_final_key, obj)
	if get_response.is_successful():
		var cached_texture: Texture2D = get_response.value
		if cached_texture != null:
			return cached_texture

	var built_texture: Texture2D = _build_texture()
	var set_response = cache.set(_final_key, built_texture, null, obj)
	return set_response.value

## Removes the caller reference for this context final key
## from the configured LRU cache.
func dispose(obj, cache_key: String):
	assert(not invalid, "This context is invalid. It cannot be processed")
	if invalid:
		return

	var cache = _LRURegistry.fetch(cache_key)
	if cache == null:
		return

	cache.delete(_final_key, obj)
