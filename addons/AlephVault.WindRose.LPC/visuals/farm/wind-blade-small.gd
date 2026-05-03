@tool
extends AlephVault__WindRose.Maps.Visuals.StaticMapEntityVisual


const _WIND_BLADE_SMALL_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-wind-blade-small.png")
const _FRAME_COUNT := 4
const _DEFAULT_FPS := 4


func _init() -> void:
	fps = _DEFAULT_FPS
	_setup_sprite()


func _ready() -> void:
	_setup_sprite()


func _setup_sprite() -> void:
	texture = _WIND_BLADE_SMALL_TEXTURE
	region_enabled = true
	region_filter_clip_enabled = true
	region_rect = Rect2(Vector2.ZERO, Vector2(64, 256))
	hframes = 1
	vframes = _FRAME_COUNT
	_vertically_distributed = true
	_region_rect_up = Rect2()
	_region_rect_left = Rect2()
	_region_rect_right = Rect2()


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
