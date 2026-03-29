@tool
extends Sprite2D

const BARN_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-barn.png")

enum Flavor {
	SMALL,
	MEDIUM,
	BIG,
}

const FLAVOR_REGION_RECTS := {
	Flavor.SMALL: Rect2i(0, 0, 192, 288),
	Flavor.MEDIUM: Rect2i(224, 0, 192, 416),
	Flavor.BIG: Rect2i(448, 0, 416, 416),
}

@export var flavor: Flavor = Flavor.SMALL:
	set(value):
		flavor = value
		_update_sprite()


func _init() -> void:
	_update_sprite()


func _ready() -> void:
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
	texture = BARN_TEXTURE
	hframes = 1
	vframes = 1
	frame = 0
	frame_coords = Vector2i.ZERO
	region_enabled = true
	region_rect = FLAVOR_REGION_RECTS.get(flavor, FLAVOR_REGION_RECTS[Flavor.SMALL])
	region_filter_clip_enabled = true
