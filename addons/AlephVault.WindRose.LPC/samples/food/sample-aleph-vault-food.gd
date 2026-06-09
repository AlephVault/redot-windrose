extends AlephVault__WindRose__LPC.Visuals.Farm.FoodIcon


var _was_q_pressed := false
var _was_w_pressed := false
var _was_e_pressed := false


func _ready() -> void:
	super()
	set_process(true)


func _process(_delta: float) -> void:
	super(_delta)
	var is_q_pressed := Input.is_physical_key_pressed(KEY_Q)
	var is_w_pressed := Input.is_physical_key_pressed(KEY_W)
	var is_e_pressed := Input.is_physical_key_pressed(KEY_E)

	if is_q_pressed and not _was_q_pressed:
		food_type = _next_food_type(food_type)
		_print_values()

	if is_w_pressed and not _was_w_pressed:
		food_presentation = _next_food_presentation(food_presentation)
		_print_values()

	if is_e_pressed and not _was_e_pressed:
		food_type = _previous_food_type(food_type)
		_print_values()

	_was_q_pressed = is_q_pressed
	_was_w_pressed = is_w_pressed
	_was_e_pressed = is_e_pressed
	queue_redraw()


func _next_food_type(value: FoodType) -> int:
	var values: Array = FoodType.values()
	var current := values.find(int(value))
	if current == -1:
		return values[0]
	return values[(current + 1) % values.size()]


func _previous_food_type(value: FoodType) -> int:
	var values: Array = FoodType.values()
	var current := values.find(int(value))
	if current == -1:
		return values[0]
	return values[(current - 1 + values.size()) % values.size()]


func _next_food_presentation(value: FoodPresentation) -> int:
	return (int(value) + 1) % FoodPresentation.size()


func _print_values() -> void:
	print("Food type: %s | Stage: %s" % [
		FoodType.keys()[FoodType.values().find(int(food_type))],
		FoodPresentation.keys()[FoodPresentation.values().find(int(food_presentation))]
	])


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))
