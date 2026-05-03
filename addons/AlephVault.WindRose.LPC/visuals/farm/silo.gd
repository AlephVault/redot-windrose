@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _UTILS_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-utils.png")


## The material combination used by the silo.
enum Mode {
	BRICK_AND_TILES,
	WOOD_AND_TILES,
	BRICK_AND_THATCH,
	WOOD_AND_THATCH,
}


const _MODE_REGION_RECTS := {
	Mode.BRICK_AND_TILES: Rect2i(0, 0, 64, 160),
	Mode.WOOD_AND_TILES: Rect2i(64, 0, 64, 160),
	Mode.BRICK_AND_THATCH: Rect2i(128, 0, 64, 160),
	Mode.WOOD_AND_THATCH: Rect2i(192, 0, 64, 160),
}


## The silo mode to render.
@export var mode: Mode = Mode.BRICK_AND_TILES:
	set(value):
		if mode == value:
			return
		mode = value
		_update_sprite()


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
		_MODE_REGION_RECTS.get(mode, _MODE_REGION_RECTS[Mode.BRICK_AND_TILES])
	)
