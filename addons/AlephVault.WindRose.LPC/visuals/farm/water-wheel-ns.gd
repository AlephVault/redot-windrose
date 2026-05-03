@tool
extends AlephVault__WindRose.Maps.Visuals.StaticMapEntityVisual


const _WATER_WHEEL_NS_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-water-wheel-ns.png")
const _FRAME_COUNT := 4
const _DEFAULT_FPS := 6


enum Flow {
	SOUTH_TO_NORTH,
	NORTH_TO_SOUTH,
}


## The water flow direction represented by the wheel animation.
@export var flow: Flow = Flow.SOUTH_TO_NORTH:
	set(value):
		if flow == value:
			return
		flow = value
		_reset_animation_frame()


func _init() -> void:
	fps = _DEFAULT_FPS
	_setup_sprite()


func _ready() -> void:
	_setup_sprite()


func _setup() -> void:
	_setup_sprite()
	super._setup()
	_reset_animation_frame()


func _setup_sprite() -> void:
	texture = _WATER_WHEEL_NS_TEXTURE
	region_enabled = true
	region_filter_clip_enabled = true
	region_rect = Rect2(Vector2.ZERO, Vector2(128, 64))
	hframes = _FRAME_COUNT
	vframes = 1
	_vertically_distributed = false
	_region_rect_up = Rect2()
	_region_rect_left = Rect2()
	_region_rect_right = Rect2()


func _reset_animation_frame() -> void:
	_accumulated = 0
	_frame = _FRAME_COUNT - 1 if flow == Flow.NORTH_TO_SOUTH else 0
	if is_instance_valid(full_setup):
		_apply()


func _update(delta: float) -> void:
	if fps > 0:
		_accumulated += delta
		var frame_time := 1.0 / fps
		while _accumulated >= frame_time:
			var step := -1 if flow == Flow.NORTH_TO_SOUTH else 1
			_frame = (_frame + step + _FRAME_COUNT) % _FRAME_COUNT
			_accumulated -= frame_time
			_apply()
	else:
		_accumulated = 0


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
