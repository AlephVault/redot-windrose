extends AlephVault__WindRose__LPC.Visuals.Farm.Crop


var _was_q_pressed := false
var _was_w_pressed := false


func _ready() -> void:
	super()
	set_process(true)


func _process(_delta: float) -> void:
	super(_delta)
	var is_q_pressed := Input.is_physical_key_pressed(KEY_Q)
	var is_w_pressed := Input.is_physical_key_pressed(KEY_W)

	if is_q_pressed and not _was_q_pressed:
		crop_type = _next_crop_type(crop_type)

	if is_w_pressed and not _was_w_pressed:
		crop_stage = _next_crop_stage(crop_stage)

	_was_q_pressed = is_q_pressed
	_was_w_pressed = is_w_pressed
	queue_redraw()


func _next_crop_type(value: CropType) -> int:
	return (int(value) + 1) % CropType.size()


func _next_crop_stage(value: CropStatus) -> int:
	return (int(value) + 1) % CropStatus.size()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))
