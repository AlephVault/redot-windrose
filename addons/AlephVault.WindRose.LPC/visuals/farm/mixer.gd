@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _UTILS_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-utils.png")
const _REGION_RECT = Rect2i(0, 192, 32, 64)


func _init() -> void:
	_update_sprite()


func _ready() -> void:
	_update_sprite()


func _setup():
	_update_sprite()


func _teardown():
	pass


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


func _update_sprite() -> void:
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		self,
		_UTILS_TEXTURE,
		_REGION_RECT
	)
