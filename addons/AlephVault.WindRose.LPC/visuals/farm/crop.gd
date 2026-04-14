@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual


const _CROPS_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-crops.png")


# Each end texture will have a size of 32x64.
# This, regardless the type and stage.
#
# Stage is 0-Planted to 3-Ready, and 4-Harvested.
#
# But there are many crop types described here.


## A comprehensive list of crop types.
## It determines the plant to render.
enum CropType {
	# First row.
	RUSSET_POTATOES = 0,
	GOLD_POTATEOS = 1,
	PURPLE_POTATOES = 2,
	SWEET_POTATOES = 3,
	CASSAVA = 4,
	DAIKON_RADISHES = 5,
	CARROTS = 6,
	PARSNIPS = 7,
	RADISHES = 8,
	BEETS = 9,
	TURNIPS = 10,
	RUTABANGA = 11,
	GARLIC = 12,
	YELLOW_ONION = 13,
	RED_ONION = 14,
	WHITE_ONION = 15,
	GREEN_ONION = 16,
	HOT_PEPPER = 17,
	GREEN_BELL_PEPPER = 18,
	RED_BELL_PEPPER = 19,
	ORANGE_BELL_PEPPER = 20,
	YELLOW_BELL_PEPPER = 21,
	HOT_PEPPERS = 22,
	WATERMELON = 23,
	HONEYDEW_MELON = 24,
	CANTALOUPE_MELON = 25,
	ACORN_SQUASH = 26,
	PUMPKIN = 27,
	CROOKNECK_SQUASH = 28,
	BUTTERNUT_SQUASH = 29,
	CORN1 = 30,
	CORN2 = 31,
	
	# Second row.
	ASPARAGUS = 32,
	RHUBARB = 33,
	ROMAINE_LETTUCE = 34,
	ICEBERG_LETTUCE = 35,
	KALE = 36,
	RED_CABBAGE = 37,
	GREEN_CABBAGE = 38,
	CELERY = 39,
	BOK_CHOY = 40,
	FENNEL_BULB = 41,
	BRUSSELS_SPROUTS = 42,
	CAULIFLOWER = 43,
	BROCCOLI = 44,
	ARTICHOKE = 45,
	LEEKS = 46,
	KOHLRABI = 47,
	EGGPLANT = 48,
	ZUCCHINI = 49,
	YELLOW_SQUASH = 50,
	CUCUMBER = 51,
	STRAWBERRIES = 52,
	BLACKBERRIES = 53,
	RASPBERRIES = 54,
	BLUEBERRIES = 55,
	RED_GRAPES = 56,
	GREEN_GRAPES = 57,
	CHERRY_TOMATOES = 58,
	TOMATOES = 59,
	LARGE_TOMATOES = 60,
	PEAS = 61,
	HOPS = 62,
	GREEN_BEANS = 63,
	
	# Row 3.
	COFFEE = 64,
	PINEAPPLE = 65,
	KIWI = 66
}


## The status of a crop.
enum CropStatus {
	PLANTED = 0,
	GROWING1 = 1,
	GROWING2 = 2,
	READY = 3,
	HARVESTED = 4
}


const _CROP_SIZE := Vector2i(32, 64)
const _CROP_COLUMNS := 32
const _CROP_TYPES_PER_STAGE_ROW := 3


## The crop type to render.
@export var crop_type: CropType = CropType.RUSSET_POTATOES:
	set(value):
		if crop_type == value:
			return
		crop_type = value
		_update_sprite()


## The crop stage to render.
@export var crop_stage: CropStatus = CropStatus.PLANTED:
	set(value):
		if crop_stage == value:
			return
		crop_stage = value
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


func _get_crop_region_rect(type: CropType, status: CropStatus) -> Rect2i:
	var crop_index := int(type)
	var crop_column := crop_index % _CROP_COLUMNS
	var crop_stage_index := int(crop_stage)
	
	var crop_row := int(crop_index / _CROP_COLUMNS)
	var stage_row := int(status) + _CROP_TYPES_PER_STAGE_ROW * crop_row
	return Rect2i(Vector2i(crop_column * _CROP_SIZE.x, stage_row * _CROP_SIZE.y), _CROP_SIZE)


func _update_sprite() -> void:
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		self,
		_CROPS_TEXTURE,
		_get_crop_region_rect(crop_type, crop_stage)
	)
