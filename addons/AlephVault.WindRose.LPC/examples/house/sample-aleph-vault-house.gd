extends AlephVault__WindRose__LPC.Visuals.Farm.House


var _was_q_pressed := false
var _was_w_pressed := false
var _was_e_pressed := false
var _was_space_pressed := false


func _ready() -> void:
	super()
	set_process(true)


func _process(_delta: float) -> void:
	super(_delta)
	var is_q_pressed := Input.is_physical_key_pressed(KEY_Q)
	var is_w_pressed := Input.is_physical_key_pressed(KEY_W)
	var is_e_pressed := Input.is_physical_key_pressed(KEY_E)
	var is_space_pressed := Input.is_physical_key_pressed(KEY_SPACE)

	if is_q_pressed and not _was_q_pressed:
		wall_color = _next_brick_color(wall_color)

	if is_w_pressed and not _was_w_pressed:
		ceiling_color = _next_brick_color(ceiling_color)

	if is_e_pressed and not _was_e_pressed:
		chimney_color = _next_brick_color(chimney_color)

	if is_space_pressed and not _was_space_pressed:
		window_lights_on = not window_lights_on

	_was_q_pressed = is_q_pressed
	_was_w_pressed = is_w_pressed
	_was_e_pressed = is_e_pressed
	_was_space_pressed = is_space_pressed
	queue_redraw()


func _next_brick_color(color: BrickColor) -> int:
	return (int(color) + 1) % BrickColor.size()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))
