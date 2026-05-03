@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _UTILS_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-utils.png")


## The waterer layout.
enum Layout {
	VERTICAL,
	HORIZONTAL,
}


## Whether the waterer is filled or empty.
enum FillStatus {
	EMPTY,
	FULL,
}


const _VERTICAL_FULL_REGION_RECT = Rect2i(192, 160, 32, 64)
const _VERTICAL_EMPTY_REGION_RECT = Rect2i(224, 160, 32, 64)
const _HORIZONTAL_EMPTY_REGION_RECT = Rect2i(128, 224, 64, 32)
const _HORIZONTAL_FULL_REGION_RECT = Rect2i(192, 224, 64, 32)


## The waterer layout to render.
@export var layout: Layout = Layout.VERTICAL:
	set(value):
		if layout == value:
			return
		layout = value
		_update_sprite()


## Whether the waterer is filled or empty.
@export var fill_status: FillStatus = FillStatus.FULL:
	set(value):
		if fill_status == value:
			return
		fill_status = value
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


func _get_region_rect() -> Rect2i:
	match layout:
		Layout.HORIZONTAL:
			if fill_status == FillStatus.FULL:
				return _HORIZONTAL_FULL_REGION_RECT
			return _HORIZONTAL_EMPTY_REGION_RECT
		_:
			if fill_status == FillStatus.EMPTY:
				return _VERTICAL_EMPTY_REGION_RECT
			return _VERTICAL_FULL_REGION_RECT


func _update_sprite() -> void:
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		self,
		_UTILS_TEXTURE,
		_get_region_rect()
	)
