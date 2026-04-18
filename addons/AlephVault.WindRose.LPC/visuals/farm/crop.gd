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
	RUSSET_POTATOES,
	GOLD_POTATEOS,
	PURPLE_POTATOES,
	SWEET_POTATOES,
	CASSAVA,
	DAIKON_RADISHES,
	CARROTS,
	PARSNIPS,
	RADISHES,
	BEETS,
	TURNIPS,
	RUTABANGA,
	GARLIC,
	YELLOW_ONION,
	RED_ONION,
	WHITE_ONION,
	GREEN_ONION,
	HOT_PEPPER,
	GREEN_BELL_PEPPER,
	RED_BELL_PEPPER,
	ORANGE_BELL_PEPPER,
	YELLOW_BELL_PEPPER,
	HOT_PEPPERS,
	WATERMELON,
	HONEYDEW_MELON,
	CANTALOUPE_MELON,
	ACORN_SQUASH,
	PUMPKIN,
	CROOKNECK_SQUASH,
	BUTTERNUT_SQUASH,
	CORN1,
	CORN2,
	
	# Second row.
	ASPARAGUS,
	RHUBARB,
	ROMAINE_LETTUCE,
	ICEBERG_LETTUCE,
	KALE,
	RED_CABBAGE,
	GREEN_CABBAGE,
	CELERY,
	BOK_CHOY,
	FENNEL_BULB,
	BRUSSELS_SPROUTS,
	CAULIFLOWER,
	BROCCOLI,
	ARTICHOKE,
	LEEKS,
	KOHLRABI,
	EGGPLANT,
	ZUCCHINI,
	YELLOW_SQUASH,
	CUCUMBER,
	STRAWBERRIES,
	BLACKBERRIES,
	RASPBERRIES,
	BLUEBERRIES,
	RED_GRAPES,
	GREEN_GRAPES,
	CHERRY_TOMATOES,
	TOMATOES,
	LARGE_TOMATOES,
	PEAS,
	HOPS,
	GREEN_BEANS,
	
	# Row 3.
	COFFEE,
	PINEAPPLE,
	KIWI
}


## The status of a crop.
enum CropStatus {
	PLANTED,
	GROWING1,
	GROWING2,
	READY,
	HARVESTED
}


const _CROP_SIZE := Vector2i(32, 64)
const _CROP_COLUMNS := 32
const _CROP_STATUSES := 5


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
	var stage_row := int(status) + _CROP_STATUSES * crop_row
	return Rect2i(Vector2i(crop_column * _CROP_SIZE.x, stage_row * _CROP_SIZE.y), _CROP_SIZE)


func _update_sprite() -> void:
	AlephVault__WindRose__LPC.Utils.Sprites.fix_static_sprite(
		self,
		_CROPS_TEXTURE,
		_get_crop_region_rect(crop_type, crop_stage)
	)
