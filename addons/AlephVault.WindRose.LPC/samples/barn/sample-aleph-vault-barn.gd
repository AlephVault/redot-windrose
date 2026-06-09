extends AlephVault__WindRose__LPC.Visuals.Farm.Barn

var _was_space_pressed := false


func _ready() -> void:
	super()
	set_process(true)


func _process(_delta: float) -> void:
	super(_delta)
	var is_space_pressed := Input.is_physical_key_pressed(KEY_SPACE)

	if is_space_pressed and not _was_space_pressed:
		gate_status = GateStatus.OPEN
	elif not is_space_pressed and _was_space_pressed:
		gate_status = GateStatus.CLOSED

	_was_space_pressed = is_space_pressed
	queue_redraw() # This calls the _draw() function


func _draw() -> void:
	# Draw a red circle with a radius of 5 pixels at the pivot (local 0, 0)
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))
