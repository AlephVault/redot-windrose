@tool
extends Sprite2D


const BARN_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-barn.png")


## The flavor (size) of the barn.
enum Flavor {
	SMALL,
	MEDIUM,
	BIG,
}


## The status of the gate.
enum GateStatus {
	OPEN,
	CLOSED
}


const _FLAVOR_REGION_RECTS := {
	Flavor.SMALL: Rect2i(0, 0, 192, 288),
	Flavor.MEDIUM: Rect2i(224, 0, 192, 416),
	Flavor.BIG: Rect2i(448, 0, 416, 416),
}


const _GATE_REGION_RECT = Rect2i(32, 320, 160, 416)


## The flavor for this barn. It displays a different image
## depending on the selected value.
@export var flavor: Flavor = Flavor.SMALL:
	set(value):
		flavor = value
		_update_sprite()


func _init() -> void:
	_update_sprite()


func _ready() -> void:
	_update_sprite()
	set_process(true)

func _process(delta):
	queue_redraw() # This calls the _draw() function

func _draw():
	# Draw a red circle with a radius of 5 pixels at the pivot (local 0, 0)
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))

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
	region_rect = _FLAVOR_REGION_RECTS.get(flavor, _FLAVOR_REGION_RECTS[Flavor.SMALL])
	region_filter_clip_enabled = true
	offset = Vector2i(0, -region_rect.size.y)
	centered = false
