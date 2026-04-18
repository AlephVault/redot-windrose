@tool
extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual

# This class talks about 3 different files. They stand for:
# 1. The vegetables, fruits and mushrooms.
# 2. The breads and pastries.
# 3. The animal products.

# There's something else to consider here:
# 1. The items in [1] support a mode of showing stuff in a
#    container. All of them. Those regions are 32x64, rather
#    then 32x32.
# 2. While the breads and pastry, and animal products, also
#    have support for that in certain sprites, not all of them
#    have that representation and perhaps need another type of
#    container. I'll not add support for them so far, but can
#    consider doing it in a future revision.
# 3. Some items in [3] don't support multiple quantities, but
#    only one icon. There are explicitly other items for the
#    representation of bigger quantities, and they have other
#    size(s) instead. They'll be handles irregularly.
# 4. Certain things from bread will not be supported.

const _ANIMAL_PRODUCTS_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-food-animal-products.png")
const _BREAD_AND_PASTRY_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-food-bread-and-pastry.png")
const _FRUITS_AND_VEGGIES_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/farm/lpc-farm-food-fruits-and-veggies.png")

# The size for a food icon, in different amounts.
const _ICON_SIZE = Vector2i(32, 32)

# The size for some special big food icons.
const _BIG_ICON_SIZE = Vector2i(32, 64)

# The size for a batched representation of food.
const _BATCHED_ICON_SIZE = Vector2i(32, 64)

const _CATEGORY_SPAN: int = 100000
const _SUBCATEGORY_SPAN: int = 10000

# Constants for bread and pastries.
const _BP = 0
# Section 1 of B & P.
const _BP1 = _BP + 0
# Section 2 of B & P.
const _BP2 = _BP + _SUBCATEGORY_SPAN

# Constants for fruits and veggies (and shrooms).
const _FV = _CATEGORY_SPAN
# Section for Vegetables.
const _FV_VEGS = _FV + 0
# Section for Shrooms.
const _FV_SHROOMS = _FV + _SUBCATEGORY_SPAN
# Section for Fruits.
const _FV_FRUITS = _FV + _SUBCATEGORY_SPAN * 2

# Constants for animal products.
const _AP = _CATEGORY_SPAN * 2
# Section for milk-derived and egg-derived products.
const _AP_MILK_EGGS = _AP + 0
# Section for Cattle meats.
const _AP_CATTLE_MEAT = _AP + _SUBCATEGORY_SPAN
# Section for Fish / lobster meats.
const _AP_SEAFOOD1 = _AP + _SUBCATEGORY_SPAN * 2
# Section for other seafood.
const _AP_SEAFOOD2 = _AP + _SUBCATEGORY_SPAN * 3

## All the food types defined here are supported in
## one of the images
enum FoodType {
	# Animal products: Milk/Egg-derived products.
	BRIE_CHEESE = _AP_MILK_EGGS,
	GOUDA_CHEESE,
	WHITE_SWISS_CHEESE,
	CHEDDAR_CHEESE,
	YELLOW_SWISS_CHEESE,
	SMOKED_GRUYERE_CHEESE,
	MUENSTER_CHEESE,
	BLUE_CHEESE,
	FETA_CHEESE,
	MOZARELLA_CHEESE,
	MANCHEGO_CHEESE,
	JACK_CHEESE,
	PARMESAN_CHEESE,
	WHITE_EGGS,
	BROWN_EGGS,
	HARDBOILED_EGGS,
	FRIED_EGGS,
	SCRAMBLED_EGGS,
	BUTTER,
	
	# Animal products: Cattle meats.
	CHICKEN = _AP_CATTLE_MEAT,
	CHICKEN_DRUMSTICK,
	ROTISSERIE_CHICKEN,
	LARGE_CHICKEN_DRUMSTICK,
	TURKEY,                    # Only sprite for 'small'.
	CHICKEN_BREAST,
	CHICKEN_BREAST_MEDIUM,
	CHICKEN_BREAST_SMALL,
	CHOP,
	SAUSAGE,
	RIBEYE_STEAK,
	RIBEYE_STEAK_SMALL,
	TBONE_STEAK,
	RIB_ROAST,                 # Only sprite for 'small' (incl. medium) and 'big'.
	SLICED_RIB_ROAST,
	BACK_RIBS,                 # Only sprite for 'small' (incl. medium) and 'big'.
	HAM,
	PORK_CHOP,
	PORK_CHOP_SMALL,
	BACON,
	LAMB_CHOP,
	KEBAB,
	MEATBALL,
	
	# Animal products: Fish, Calamari and Lobster.
	ANCHOVY = _AP_SEAFOOD1,
	PERCH,
	SALMON,
	TROUT,
	CATFISH,
	WALLEYE,
	CARP,
	BASS,
	FLOUNDER,
	COD,
	TILAPIA,
	HERRING,
	HADDOCK,
	CALAMARI,
	LOBSTER,
	
	# Animal products: Other seafood.
	MUSSEL = _AP_SEAFOOD2,
	SCALLOP,
	OYSTER,
	CRAB
	
	# TODO: Add bread and pastries.
	# TODO: Add fruits, shrooms and veggies.
}

## The presentation of the food. Typically: small,
## medium and big. Fruits, shrooms and vegetables
## support also: batch (others will render big if
## batch is selected). The 'medium' one means
## 'rotated' for the Seafood 1 category.
enum FoodPresentation {
	SMALL,
	MEDIUM,
	BIG,
	BATCH
}

# Picks the appropriate elements to be used when
# generating the rectangle.
@warning_ignore("integer_division")
func _pick_data(value: FoodType, presentation: FoodPresentation):
	var value_: int = int(value)
	var tx: Texture2D
	var pivot: Vector2i
	var size: Vector2i = _ICON_SIZE

	var category: int = (value_ / _CATEGORY_SPAN) * _CATEGORY_SPAN
	var subcategory: int = (value_ / _SUBCATEGORY_SPAN) * _SUBCATEGORY_SPAN
	var index: int = value_ - subcategory
	
	if category == _BP:
		tx = _BREAD_AND_PASTRY_TEXTURE
		if presentation == FoodPresentation.BATCH:
			presentation == FoodPresentation.BIG

		if subcategory == _BP1:
			pivot = Vector2(32 * index, 32 * int(presentation))
			return [
				tx, pivot, size
			] 
		elif subcategory == _BP2:
			# The index 21 corresponds to the in-image position
			# Of the first image in the second section.
			pivot = Vector2(32 * (index + 21), 32 * int(presentation))
			return [
				tx, pivot, size
			]

		return null
	elif category == _AP:
		tx = _ANIMAL_PRODUCTS_TEXTURE
		if presentation == FoodPresentation.BATCH:
			presentation == FoodPresentation.BIG
	
		if subcategory == _AP_MILK_EGGS:
			pivot = Vector2(32 * index, 32 * int(presentation))
			return [
				tx, pivot, size
			] 
		elif subcategory == _AP_CATTLE_MEAT:
			pivot = Vector2(32 * index, 32 * (int(presentation) + 5))
			if value == FoodType.BACK_RIBS or value == FoodType.RIB_ROAST:
				if presentation == FoodPresentation.MEDIUM:
					presentation = FoodPresentation.SMALL
				elif presentation == FoodPresentation.BIG:
					size = _BIG_ICON_SIZE
			elif value == FoodType.TURKEY:
				presentation == FoodPresentation.SMALL
			return [
				tx, pivot, size
			] 
		elif subcategory == _AP_SEAFOOD1:
			pivot = Vector2(32 * index, 32 * (int(presentation) + 15))
			return [
				tx, pivot, size
			] 
		elif subcategory == _AP_SEAFOOD2:
			pivot = Vector2(32 * (index + 28), 32 * (int(presentation) + 15))
			return [
				tx, pivot, size
			] 
		
		return null
	elif category == _FV:
		tx = _FRUITS_AND_VEGGIES_TEXTURE
		if presentation == FoodPresentation.BATCH:
			size = _BATCHED_ICON_SIZE
		
		if subcategory == _FV_VEGS:
			pivot = Vector2(32 * (index % 32), 32 * (int(presentation) + 5 * (index / 32)))
			return [
				tx, pivot, size
			] 
		elif subcategory == _FV_SHROOMS:
			pivot = Vector2(32 * index, 800 + 32 * int(presentation))
			return [
				tx, pivot, size
			] 
		elif subcategory == _FV_FRUITS:
			pivot = Vector2(32 * index, 960 + 32 * int(presentation))
			return [
				tx, pivot, size
			]
	
	return null
