extends AlephVault__WindRose__LPC.Visuals.Farm.House


var _was_q_pressed := false
var _was_w_pressed := false
var _was_e_pressed := false
var _was_space_pressed := false
var _was_a_pressed := false
var _was_s_pressed := false
var _was_d_pressed := false
var _was_f_pressed := false
var _was_r_pressed := false


func _ready() -> void:
	super()
	set_process(true)


func _process(_delta: float) -> void:
	super(_delta)
	var is_q_pressed := Input.is_physical_key_pressed(KEY_Q)
	var is_w_pressed := Input.is_physical_key_pressed(KEY_W)
	var is_e_pressed := Input.is_physical_key_pressed(KEY_E)
	var is_space_pressed := Input.is_physical_key_pressed(KEY_SPACE)
	var is_a_pressed := Input.is_physical_key_pressed(KEY_A)
	var is_s_pressed := Input.is_physical_key_pressed(KEY_S)
	var is_d_pressed := Input.is_physical_key_pressed(KEY_D)
	var is_f_pressed := Input.is_physical_key_pressed(KEY_F)
	var is_r_pressed := Input.is_physical_key_pressed(KEY_R)

	if is_q_pressed and not _was_q_pressed:
		wall_color = _next_brick_color(wall_color)

	if is_w_pressed and not _was_w_pressed:
		ceiling_color = _next_brick_color(ceiling_color)

	if is_e_pressed and not _was_e_pressed:
		chimney_color = _next_brick_color(chimney_color)

	if is_space_pressed and not _was_space_pressed:
		lights_on = not lights_on

	if is_a_pressed and not _was_a_pressed:
		door_color = _next_door_color(door_color)

	if is_s_pressed and not _was_s_pressed:
		door_is_open = not door_is_open

	if is_d_pressed and not _was_d_pressed:
		door_has_windows = not door_has_windows

	if is_f_pressed and not _was_f_pressed:
		doorframe_color = _next_doorframe_color(doorframe_color)

	if is_r_pressed and not _was_r_pressed:
		has_doorframe = not has_doorframe

	_was_q_pressed = is_q_pressed
	_was_w_pressed = is_w_pressed
	_was_e_pressed = is_e_pressed
	_was_space_pressed = is_space_pressed
	_was_a_pressed = is_a_pressed
	_was_s_pressed = is_s_pressed
	_was_d_pressed = is_d_pressed
	_was_f_pressed = is_f_pressed
	_was_r_pressed = is_r_pressed
	queue_redraw()


func _next_brick_color(color: BrickColor) -> int:
	return (int(color) + 1) % BrickColor.size()


func _next_door_color(color: DoorColor) -> int:
	return (int(color) + 1) % DoorColor.size()


func _next_doorframe_color(color: DoorframeColor) -> int:
	return (int(color) + 1) % DoorframeColor.size()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))
