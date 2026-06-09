@tool
extends AlephVault__WindRose__REFMAP.Visuals.People.Simple
## This REFMAP subclass adds, on top of the Simple REFMAP
## visual, the ability to show the following:
##
## - Name: The name. It will be rendered below the visual.
## - Description: An optional description. Rendered below
##   the name.
## - Message: The message. Rendered above the head.

const _Strings = AlephVault__WindRose__REFMAP.Utils.Strings
const _NAME_TRAIT := &"name"
const _DESCRIPTION_TRAIT := &"description"
const _MESSAGE_TRAIT := &"message"
const _NAME_POSITION := Vector2(16, 40)
const _DESCRIPTION_POSITION := Vector2(16, 64)
const _MESSAGE_POSITION := Vector2(16, -24)
const _LABEL_WIDTH := 160.0
const _MESSAGE_WIDTH := 160.0
const _LINE_SIZE := 16

@export var _default_name_color: Color = Color.GRAY:
	set(value):
		_default_name_color = value
		if _name_uses_default_color:
			_name_color = value
		_refresh_name_label()

@export var _default_description_color: Color = Color.GRAY:
	set(value):
		_default_description_color = value
		if _description_uses_default_color:
			_description_color = value
		_refresh_description_label()

@export var _default_message_color: Color = Color.WHITE:
	set(value):
		_default_message_color = value
		if _message_uses_default_color:
			_message_color = value
		_refresh_message_label()

@export var _description_format: String = "%s":
	set(value):
		_description_format = str(value)
		_refresh_description_label()

var _name_label: Label
var _description_label: Label
var _message_label: Label
var _name_text: String = ""
var _description_text: String = ""
var _message_text: String = ""
var _name_color: Color = _default_name_color
var _description_color: Color = _default_description_color
var _message_color: Color = _default_message_color
var _name_uses_default_color := true
var _description_uses_default_color := true
var _message_uses_default_color := true

var name_text:
	set(value):
		var parsed := _parse_label_value(value, _default_name_color, false)
		_name_text = parsed[0]
		_name_color = parsed[1]
		_name_uses_default_color = parsed[2]
		_refresh_name_label()
	get:
		return [_name_text, _name_color]

var description:
	set(value):
		var parsed := _parse_label_value(value, _default_description_color, false)
		_description_text = parsed[0]
		_description_color = parsed[1]
		_description_uses_default_color = parsed[2]
		_refresh_description_label()
	get:
		return [_description_text, _description_color]

var message:
	set(value):
		var parsed := _parse_label_value(value, _default_message_color, true)
		_message_text = parsed[0]
		_message_color = parsed[1]
		_message_uses_default_color = parsed[2]
		_refresh_message_label()
	get:
		return [_message_text, _message_color]

func _init() -> void:
	super._init()
	_ensure_labels()

func _ready() -> void:
	_ensure_labels()
	super._ready()

func _get_traits_properties() -> Array[StringName]:
	var properties := super._get_traits_properties()
	properties.append_array([_NAME_TRAIT, _DESCRIPTION_TRAIT, _MESSAGE_TRAIT])
	return properties

func _apply_traits(new_traits: Dictionary) -> void:
	if new_traits.has(_NAME_TRAIT):
		name_text = new_traits[_NAME_TRAIT]
	if new_traits.has(_DESCRIPTION_TRAIT):
		description = new_traits[_DESCRIPTION_TRAIT]
	if new_traits.has(_MESSAGE_TRAIT):
		message = new_traits[_MESSAGE_TRAIT]
	var forwarded_traits := new_traits.duplicate()
	forwarded_traits.erase(_NAME_TRAIT)
	forwarded_traits.erase(_DESCRIPTION_TRAIT)
	forwarded_traits.erase(_MESSAGE_TRAIT)
	if not forwarded_traits.is_empty():
		super._apply_traits(forwarded_traits)

func _ensure_labels() -> void:
	if not is_instance_valid(_name_label):
		_name_label = Label.new()
		_name_label.name = "NameLabel"
		add_child(_name_label, false, Node.INTERNAL_MODE_FRONT)
		_configure_plain_label(_name_label)
	if not is_instance_valid(_description_label):
		_description_label = Label.new()
		_description_label.name = "DescriptionLabel"
		add_child(_description_label, false, Node.INTERNAL_MODE_FRONT)
		_configure_plain_label(_description_label)
	if not is_instance_valid(_message_label):
		_message_label = Label.new()
		_message_label.name = "MessageLabel"
		add_child(_message_label, false, Node.INTERNAL_MODE_FRONT)
		_configure_message_label(_message_label)
	_refresh_name_label()
	_refresh_description_label()
	_refresh_message_label()

func _parse_label_value(value, default_color: Color, allow_newlines: bool) -> Array:
	var uses_default_color := false
	if value is String:
		value = [value, default_color]
		uses_default_color = true
	elif not (value is Array) or value.size() < 2:
		value = [str(value), default_color]
		uses_default_color = true
	var text := _Strings.normalize(str(value[0]), allow_newlines)
	var color := _parse_color(value[1], default_color)
	return [text, color, uses_default_color]

func _parse_color(value, default_color: Color) -> Color:
	if value is Color:
		return value
	if value is int:
		var rgba: int = value & 0xffffffff
		return Color(
			float((rgba >> 24) & 0xff) / 255.0,
			float((rgba >> 16) & 0xff) / 255.0,
			float((rgba >> 8) & 0xff) / 255.0,
			float(rgba & 0xff) / 255.0
		)
	return default_color

func _configure_common_label(label: Label) -> void:
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	label.add_theme_font_size_override("font_size", _LINE_SIZE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 1)
	label.add_theme_color_override("font_shadow_color", Color.BLACK)
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)

func _configure_plain_label(label: Label) -> void:
	_configure_common_label(label)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.clip_text = false

func _configure_message_label(label: Label) -> void:
	_configure_common_label(label)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.clip_text = false

func _refresh_plain_label(label: Label, text: String, color: Color, base_position: Vector2) -> void:
	if not is_instance_valid(label):
		return
	label.text = text
	label.add_theme_color_override("font_color", color)
	var height := label.get_combined_minimum_size().y
	label.size = Vector2(_LABEL_WIDTH, height)
	label.position = base_position - Vector2(_LABEL_WIDTH * 0.5, 0)
	label.pivot_offset = Vector2(_LABEL_WIDTH * 0.5, 0)

func _refresh_name_label() -> void:
	_refresh_plain_label(_name_label, _name_text, _name_color, _NAME_POSITION)

func _refresh_description_label() -> void:
	_refresh_plain_label(_description_label, _format_description(), _description_color, _DESCRIPTION_POSITION)

func _format_description() -> String:
	if _description_text.is_empty():
		return ""
	if _description_format.count("%") == 0:
		return _description_format + _description_text
	return _description_format % _description_text

func _refresh_message_label() -> void:
	if not is_instance_valid(_message_label):
		return
	_message_label.text = _message_text
	_message_label.add_theme_color_override("font_color", _message_color)
	_message_label.size = Vector2(_MESSAGE_WIDTH, 0)
	var height = _message_label.get_minimum_size().y
	if height <= 0:
		height = _message_label.get_combined_minimum_size().y
	_message_label.size = Vector2(_MESSAGE_WIDTH, height)
	_message_label.position = _MESSAGE_POSITION - Vector2(_MESSAGE_WIDTH * 0.5, height)
	_message_label.pivot_offset = Vector2(_MESSAGE_WIDTH * 0.5, height)
