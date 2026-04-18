@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _FRUIT_TREES_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-fruit-trees.png")


# The fruit trees defined here are not complete and
# belong only to the definition of fruit trees in
# the current texture. Future versions might include
# other texture and then other definitions of the
# enums (always enhancing the symbols) and way more
# elements. But, typically, always respecting the
# 4+3 frames.


# All the trees have this size. This file is
# organized in cells, each of this size.
const _TREE_SIZE: Vector2i = Vector2i(96, 128)


# All the trees have a base tree type. Each base
# tree T will have its frames at cells (x=T, y=3)
# down to (x=T, y=0). Four frames.
enum _BaseTreeType {
	APPLE = 0,
	CITRIC,
	TROPICAL,
	CHERRY,
	PEAR,
	PLUM,
	PALMTREE,
	BANANA
}


enum TreeType {
	# Apple
	RED_APPLES = 0,
	GREEN_APPLES,
	YELLOW_APPLES,
	VARIEGATED_APPLES,
	GOLDEN_APPLES,
	# Citric
	LEMON = 100,
	LIME,
	TANGERINE,
	ORANGE,
	# Tropical
	PEACH = 200,
	MANGO1,
	MANGO2,
	# Cherry
	RED_CHERRY = 300,
	# Pear
	YELLOW_PEAR = 400,
	BROWN_PEAR,
	GREEN_PEAR,
	# Plums
	PURPLE_PLUM = 600,
	# Coconuts
	BROWN_COCONUT = 700,
	# Bananas
	YELLOW_BANANA = 800
}


# This is an internal mapping of coordinates for
# the specific +3 frames of each tree. The scheme
# of the numbers supports columns 0 to 99, and
# any arbitrary amount of rows.
#
# Now, notice how rows 6 and 9 are used and not
# the 7 and 8 rows. This is because, for these
# fruit trees, three frames are distributed. The
# first stage, for RED_APPLES, is at 700 while the
# second stage is at 600. The same applies to the
# 900 or MANGO1: They are distributed vertically
# where the first fruit stage is at 1000 and the
# secund fruit stage is at 900. Then, the later
# fruit stage (ripe and ready) is the 800 one.
const _FRUIT_STAGE_COORDINATES: Dictionary = {
	TreeType.RED_APPLES: 500, # Row 6, column 0
	TreeType.GREEN_APPLES: 501, # Row 6, column 1
	TreeType.YELLOW_APPLES: 502, # Row 6, column 2
	TreeType.VARIEGATED_APPLES: 503, # Row 6, column 3
	TreeType.GOLDEN_APPLES: 504, # Row 6, column 4
	TreeType.LEMON: 505, # Row 6, column 5
	TreeType.LIME: 506, # Row 6, column 6
	TreeType.TANGERINE: 507, # Row 6, column 7
	TreeType.ORANGE: 508, # Row 6, column 8
	TreeType.PEACH: 509, # Row 6, column 9
	TreeType.MANGO1: 800, # Row 9, column 0
	TreeType.MANGO2: 801, # Row 9, column 1
	TreeType.RED_CHERRY: 802, # Row 9, column 2
	TreeType.YELLOW_PEAR: 803, # Row 9, column 3
	TreeType.BROWN_PEAR: 804, # Row 9, column 4
	TreeType.GREEN_PEAR: 805, # Row 9, column 5
	TreeType.PURPLE_PLUM: 807, # Row 9, column 7
	TreeType.BROWN_COCONUT: 808, # Row 9, column 8
	TreeType.YELLOW_BANANA: 809, # Row 9, column 9
}


## The stage of a tree. The first four stages refer
## to a young tree growing. The 5-7 stages refer to
## the adult tree producing fruits.
enum TreeStage {
	BABY,
	SMALL,
	GROWING,
	ADULT,
	FRUITS_SMALL,
	FRUITS_GROWING,
	FRUITS_READY
}


## The tree type to render.
@export var tree_type: TreeType = TreeType.RED_APPLES:
	set(value):
		if tree_type == value:
			return
		tree_type = value
		_update_sprite()


## The tree stage to render.
@export var tree_stage: TreeStage = TreeStage.BABY:
	set(value):
		if tree_stage == value:
			return
		tree_stage = value
		_update_sprite()


func _init() -> void:
	_update_sprite()


func _ready() -> void:
	_update_sprite()


func _setup():
	_update_sprite()


func _teardown():
	pass


func _pause():
	pass


func _resume():
	pass


func _update(_delta: float):
	_update_sprite()


func _validate_property(property: Dictionary) -> void:
	if property.name in [
		"texture",
		"hframes",
		"vframes",
		"frame",
		"frame_coords",
		"region_enabled",
		"region_rect",
		"region_filter_clip_enabled",
	]:
		property.usage = PROPERTY_USAGE_NO_EDITOR


func _get_base_tree_type(type: TreeType) -> _BaseTreeType:
	return int(int(type) / 100)


func _get_tree_region_rect(type: TreeType, stage: TreeStage) -> Rect2i:
	var column := 0
	var row := 0

	if int(stage) <= int(TreeStage.ADULT):
		column = int(_get_base_tree_type(type))
		row = int(TreeStage.ADULT) - int(stage)
	else:
		var anchor: int = _FRUIT_STAGE_COORDINATES.get(type, _FRUIT_STAGE_COORDINATES[TreeType.RED_APPLES])
		column = anchor % 100
		row = int(anchor / 100) + (int(TreeStage.FRUITS_READY) - int(stage))

	return Rect2i(Vector2i(column * _TREE_SIZE.x, row * _TREE_SIZE.y), _TREE_SIZE)


func _update_sprite() -> void:
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		self,
		_FRUIT_TREES_TEXTURE,
		_get_tree_region_rect(tree_type, tree_stage)
	)
