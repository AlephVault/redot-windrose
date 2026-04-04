@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _BARN_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-barn.png")


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


const _GATE_REGION_RECT = Rect2i(32, 320, 128, 96)


var _gate: Sprite2D = null


## The flavor for this barn. It displays a different image
## depending on the selected value.
@export var flavor: Flavor = Flavor.SMALL:
	set(value):
		flavor = value
		_update_sprite()


## The status of the gate. It can be open or closed. It displays
## the gate if open, or hides it if closed.
@export var gate_status: GateStatus = GateStatus.CLOSED:
	set(value):
		gate_status = value
		_update_sprite()


func _init() -> void:
	_update_sprite()


func _ready() -> void:
	_update_sprite()


func _setup():
	_update_sprite()


func _teardown():
	if is_instance_valid(_gate):
		_gate.visible = false


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
		self, _BARN_TEXTURE, _FLAVOR_REGION_RECTS.get(flavor, _FLAVOR_REGION_RECTS[Flavor.SMALL])
	)
	if not is_instance_valid(_gate):
		_gate = Sprite2D.new()
	var _gate_parent = _gate.get_parent()
	if _gate_parent == null:
		add_child(_gate)
	elif _gate_parent != self:
		_gate.reparent(self)
	
	if gate_status == GateStatus.CLOSED:
		AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
			_gate, _BARN_TEXTURE, _GATE_REGION_RECT
		)
		_gate.scale = Vector2i.ONE
		_gate.rotation = 0
		_gate.position = Vector2i((region_rect.size.x - _GATE_REGION_RECT.size.x) / 2, 0)
		_gate.visible = true
	else:
		_gate.visible = false
