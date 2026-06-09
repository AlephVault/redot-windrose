@tool
extends AlephVault__WindRose__REFMAP.Visuals.People.Standard
## This REFMAP subclass adds, on top of the Standard REFMAP
## visual, the ability to show the following:
##
## - Name: The name. It will be rendered below the visual.
## - Description: An optional description. Rendered below
##   the name.
## - Message: The message. Rendered above the head.

const _NAME_TRAIT := &"name"
const _DESCRIPTION_TRAIT := &"name"
const _MESSAGE_TRAIT := &"message"
const _NAME_POSITION := Vector2(16, 40)
const _DESCRIPTION_POSITION := Vector2(16, 40)
const _MESSAGE_POSITION := Vector2(16, -24)
const _MESSAGE_WIDTH := 160.0
const _LINE_SIZE := 16

var _name_label: Label
var _message_label: Label

var _name: String = "":
	set(value):
		_name = str(value)
		_refresh_name_label()
	get:
		return _name

var name_text: String:
	set(value):
		_name = str(value)
		_refresh_name_label()
	get:
		return _name

var message: String = "":
	set(value):
		message = str(value)
		_refresh_message_label()

func _init() -> void:
	super._init()
	_ensure_labels()

func _ready() -> void:
	_ensure_labels()
	super._ready()

func _get_traits_properties() -> Array[StringName]:
	var properties := super._get_traits_properties()
	properties.append_array([_NAME_TRAIT, _MESSAGE_TRAIT])
	return properties

func _apply_traits(new_traits: Dictionary) -> void:
	if new_traits.has(_NAME_TRAIT):
		name_text = new_traits[_NAME_TRAIT]
	if new_traits.has(_MESSAGE_TRAIT):
		message = new_traits[_MESSAGE_TRAIT]
	var forwarded_traits := new_traits.duplicate()
	forwarded_traits.erase(_NAME_TRAIT)
	forwarded_traits.erase(_MESSAGE_TRAIT)
	if not forwarded_traits.is_empty():
		super._apply_traits(forwarded_traits)

func _ensure_labels() -> void:
	if not is_instance_valid(_name_label):
		_name_label = Label.new()
		_name_label.name = "NameLabel"
		add_child(_name_label, false, Node.INTERNAL_MODE_FRONT)
		_configure_name_label()
	if not is_instance_valid(_message_label):
		_message_label = Label.new()
		_message_label.name = "MessageLabel"
		add_child(_message_label, false, Node.INTERNAL_MODE_FRONT)
		_configure_message_label()
	_refresh_name_label()
	_refresh_message_label()

func _configure_common_label(label: Label, color: Color) -> void:
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label.add_theme_font_size_override("font_size", _LINE_SIZE)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 1)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)

func _configure_name_label() -> void:
	_configure_common_label(_name_label, Color(0.18, 0.18, 0.18))
	_name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_name_label.clip_text = false

func _configure_message_label() -> void:
	_configure_common_label(_message_label, Color(0.9, 0.9, 0.9))
	_message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message_label.clip_text = false

func _refresh_name_label() -> void:
	if not is_instance_valid(_name_label):
		return
	_name_label.text = _name
	var label_size := _name_label.get_combined_minimum_size()
	_name_label.size = label_size
	_name_label.position = _NAME_POSITION - Vector2(label_size.x * 0.5, 0)
	_name_label.pivot_offset = Vector2(label_size.x * 0.5, 0)

func _refresh_message_label() -> void:
	if not is_instance_valid(_message_label):
		return
	_message_label.text = message
	_message_label.size = Vector2(_MESSAGE_WIDTH, 0)
	var height = _message_label.get_minimum_size().y
	if height <= 0:
		height = _message_label.get_combined_minimum_size().y
	_message_label.size = Vector2(_MESSAGE_WIDTH, height)
	_message_label.position = _MESSAGE_POSITION - Vector2(_MESSAGE_WIDTH * 0.5, height)
	_message_label.pivot_offset = Vector2(_MESSAGE_WIDTH * 0.5, height)
