extends Sprite2D


const _HOUSE_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-house.png")


# A generic block size, since the rework
# on the texture was done for this size.
const _BLOCK_SIZE = Vector2i(288, 288)


# The size of the ceiling (includes blank,
# placeholder, space).
const _CEILING_SIZE = _BLOCK_SIZE


# The size of the walls (includes blank,
# placeholder, space).
const _WALLS_SIZE = _BLOCK_SIZE


# The size of the chimmey (includes blank,
# placeholder, space).
const _CHIMMEY_SIZE = _BLOCK_SIZE


## The theming of the bricks. Theming can
## be applied differently for chimmeys,
## walls or ceilings.
enum BrickTheme {
	LITEBLUE = 0,
	LITEGRAY = 1,
	GRAY = 2,
	LITEBROWN = 3,
	BROWN = 4,
	RED = 5
}


# Aligned indices for the brick themes for
# the ceilings.
const _CEILING_INDICES = [
	Vector2i(0, 0), 	Vector2i(1, 0), 	Vector2i(2, 0),
	Vector2i(0, 1), 	Vector2i(1, 1), 	Vector2i(2, 1),
]


# Aligned indices for the brick themes for
# the walls.
const _WALLS_INDICES = [
	Vector2i(0, 2), 	Vector2i(1, 2), 	Vector2i(2, 2),
	Vector2i(0, 3), 	Vector2i(1, 3), 	Vector2i(2, 3),
]


# Aligned indices for the brick themes for
# the chimmeys.
const _CHIMMEY_INDICES = [
	Vector2i(3, 0), 	Vector2i(4, 0), 	Vector2i(5, 0),
	Vector2i(3, 1), 	Vector2i(4, 1), 	Vector2i(5, 1),
]


# The pivot of the doorframes.
const _DOORFRAME_PIVOT = Vector2i(960, 960)


# The size of the door frames.
const _DOORFRAME_SIZE = Vector2i(64, 64)


# The position of the door frame in the house.
const _DOORFRAME_POSITION = Vector2i(80, 48)


## The theming for the door frames.
enum DoorFrameTheme {
	LITEORANGE = 0,
	DIMORANGE = 1,
	ORANGE = 2,
	LITEBROWN = 3,
	DIMBROWN = 4,
	BROWN = 5,
	LITEGRAY = 6,
	DIMGRAY = 7,
	GRAY = 8,
	LITEBLUE = 9,
	DIMBLUE = 10,
	BLUE = 11
}


# Aligned indices for the themes for the door frames.
const _DOORFRAME_INDICES = [
	Vector2i(0, 0), 	Vector2i(1, 0), 	Vector2i(2, 0),
	Vector2i(3, 0), 	Vector2i(4, 0), 	Vector2i(5, 0),
	Vector2i(0, 1), 	Vector2i(1, 1), 	Vector2i(2, 1),
	Vector2i(3, 1), 	Vector2i(4, 1), 	Vector2i(5, 1),
]


## The theme for the walls. It will use
## a different image depending on this value.
@export var walls_theme: BrickTheme:
	set(value):
		walls_theme = value
		_update_sprite()


## The theme for the ceiling. It will use
## a different image depending on this value.
@export var ceiling_theme: BrickTheme:
	set(value):
		ceiling_theme = value
		_update_sprite()


## The theme for the chimmey. It will use
## a different image depending on this value.
@export var chimmey_theme: BrickTheme:
	set(value):
		chimmey_theme = value
		_update_sprite()


## The theme for the doorframe. It will use
## a different image depending on this value.
@export var doorframe_theme: DoorFrameTheme:
	set(value):
		doorframe_theme = value
		_update_sprite()


## Whether the window is lit or not.
@export var is_window_lit: bool:
	set(value):
		is_window_lit = value
		_update_sprite()


# The position of the lit version of the window.
const _LIT_WINDOW_POSITION = Vector2i(1184, 1088)


# The position of the window, in a house.
const _WINDOW_PIVOT = Vector2i(160, 64)


# The size of the window.
const _WINDOW_SIZE = Vector2i(32, 32)


# The actual chimmey sprite.
var _chimmey: Sprite2D


# The actual ceiling sprite.
var _ceiling: Sprite2D


# The lit window sprite.
var _lit_window: Sprite2D


# The doorframe window sprite.
var _doorframe: Sprite2D


# Creates and ensures a sprite for an attribute.
func _ensure_sprite(attribute: String) -> Sprite2D:
	var sprite = get(attribute)
	if not is_instance_valid(sprite):
		set(attribute, Sprite2D.new())
		sprite = get(attribute)
	var _parent = sprite.get_parent()
	if _parent == null:
		add_child(sprite)
	elif _parent != self:
		sprite.reparent(self)
	sprite.rotation = 0
	sprite.scale = Vector2.ONE
	return sprite


# Updates the sprite to properly reflect the
# ceiling, walls, doorframe, chimmey and window.
func _update_sprite():
	var walls = self
	var ceiling = _ensure_sprite("_ceiling")
	var chimmey = _ensure_sprite("_chimmey")
	var lit_window = _ensure_sprite("_lit_window")
	var doorframe = _ensure_sprite("_doorframe")
	
	# The z_index == 1 will belong to
	# the door itself, open or not.
	# The z_index == 2 will belong to
	# the thing behind the door.
	doorframe.z_index = 3
	doorframe.position = _DOORFRAME_POSITION
	# The stairs will also use z_index
	# to 3, like the frame.
	lit_window.z_index = 4
	lit_window.position = _LIT_WINDOW_POSITION
	ceiling.z_index = 5
	ceiling.position = Vector2.ZERO
	chimmey.z_index = 6
	chimmey.position = Vector2.ZERO

	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		self, _HOUSE_TEXTURE, Rect2i(
			_WALLS_SIZE * _WALLS_INDICES[int(walls_theme)], _WALLS_SIZE
		)
	)
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		doorframe, _HOUSE_TEXTURE, Rect2i(
			_DOORFRAME_PIVOT + _DOORFRAME_SIZE * _DOORFRAME_INDICES[int(doorframe_theme)],
			_DOORFRAME_SIZE
		)
	)
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		lit_window, _HOUSE_TEXTURE, Rect2i(
			_WINDOW_PIVOT, _WINDOW_SIZE
		)
	)
	lit_window.visible = is_window_lit
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		ceiling, _HOUSE_TEXTURE, Rect2i(
			_CEILING_SIZE * _CEILING_INDICES[int(ceiling_theme)], _CEILING_SIZE
		)
	)
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		chimmey, _HOUSE_TEXTURE, Rect2i(
			_CHIMMEY_SIZE * _CHIMMEY_INDICES[int(ceiling_theme)], _CHIMMEY_SIZE
		)
	)
	# TODO choose and place the door.
	# TODO choose and place some contents.
