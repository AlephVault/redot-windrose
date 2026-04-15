extends AlephVault__WindRose__LPC.Visuals.Farm.FruitTrees


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
		tree_type = _next_tree_type(tree_type)

	if is_w_pressed and not _was_w_pressed:
		tree_stage = _next_tree_stage(tree_stage)

	_was_q_pressed = is_q_pressed
	_was_w_pressed = is_w_pressed
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color(1, 0, 0))


func _next_tree_type(value: TreeType) -> int:
	var values: Array = TreeType.values()
	var current := values.find(int(value))
	if current == -1:
		return values[0]
	return values[(current + 1) % values.size()]


func _next_tree_stage(value: TreeStage) -> int:
	var values: Array = TreeStage.values()
	var current := values.find(int(value))
	if current == -1:
		return values[0]
	return values[(current + 1) % values.size()]
