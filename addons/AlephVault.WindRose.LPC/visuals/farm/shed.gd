@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _UTILS_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-utils.png")


## The shed roof flavor.
enum Flavor {
	TILES,
	THATCH,
}


const _FLAVOR_REGION_RECTS := {
	Flavor.TILES: Rect2i(256, 224, 128, 128),
	Flavor.THATCH: Rect2i(384, 224, 128, 128),
}


## The shed roof flavor to render.
@export var flavor: Flavor = Flavor.TILES:
	set(value):
		if flavor == value:
			return
		flavor = value
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
		_FLAVOR_REGION_RECTS.get(flavor, _FLAVOR_REGION_RECTS[Flavor.TILES])
	)
