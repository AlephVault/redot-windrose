extends AlephVault__WindRose__LPC.Visuals.Farm.Waterer


var _was_q_pressed := false


func _ready() -> void:
	super()
	set_process(true)


func _process(_delta: float) -> void:
	super(_delta)
	var is_q_pressed := Input.is_physical_key_pressed(KEY_Q)

	if is_q_pressed and not _was_q_pressed:
		fill_status = _next_fill_status(fill_status)

	_was_q_pressed = is_q_pressed
	queue_redraw()


func _next_fill_status(value: FillStatus) -> int:
	return (int(value) + 1) % FillStatus.size()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))
