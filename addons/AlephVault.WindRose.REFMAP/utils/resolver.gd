extends Object

## Sex variant used by the REFMAP character assets.
enum Sex {
	Male,
	Female,
}

## Palette used by colored equipment and clothing pieces.
## Default maps to Black for bundled resolver implementations.
enum Color {
	Default,
	Black = 0,
	Blue,
	DarkBrown,
	Green,
	LightBrown,
	Pink,
	Purple,
	Red,
	White,
	Yellow,
}

## Palette used by base body sprites.
## Default maps to White for bundled resolver implementations.
enum BodyColor {
	Default,
	White = 0,
	Black,
	Yellow,
	Orange,
	Blue,
	Red,
	Green,
	Purple,
}

## Component type constants accepted by resolve/unresolve.
const RIGHT_HAND := "right_hand"
const LEFT_HAND := "left_hand"
const HAIR := "hair"
const HAIR_TAIL := "hair_tail"
const CLOTH := "cloth"
const NECKLACE := "necklace"
const HAT := "hat"
const CLOAK := "cloak"
const ARMS := "arms"
const SHOULDERS := "shoulders"
const LONG_SHIRT := "long_shirt"
const SHIRT := "shirt"
const CHEST := "chest"
const BOOTS := "boots"
const PANTS := "pants"
const WAIST := "waist"

## All non-body component type constants.
const COMPONENT_TYPES := [
	RIGHT_HAND,
	LEFT_HAND,
	HAIR,
	HAIR_TAIL,
	CLOTH,
	NECKLACE,
	HAT,
	CLOAK,
	ARMS,
	SHOULDERS,
	LONG_SHIRT,
	SHIRT,
	CHEST,
	BOOTS,
	PANTS,
	WAIST,
]

## Component keys are non-empty and cannot contain spaces or
## colons, because they are used in paths and composition keys.
func is_valid_key(key: String) -> bool:
	return key != "" and key.find(":") == -1 and key.find(" ") == -1

## Resolves a non-body component texture. Implementations should
## return Texture2D or null. Callers ignore non-Texture2D values
## and textures whose dimensions are not 128x192.
func resolve(sex: Sex, type: String, key: String, color: Color = Color.Default):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented("Resolver", "resolve")

## Releases a previous successful non-body resolve. This should
## eventually be called once for each resolve call that returned
## a non-null value.
func unresolve(sex: Sex, type: String, key: String, color: Color = Color.Default):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented("Resolver", "unresolve")

## Resolves a base body texture. Implementations should return
## Texture2D or null. Callers ignore non-Texture2D values and
## textures whose dimensions are not 128x192.
func resolve_body(sex: Sex, color: BodyColor):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented("Resolver", "resolve_body")

## Releases a previous successful body resolve. This should
## eventually be called once for each resolve_body call that
## returned a non-null value.
func unresolve_body(sex: Sex, color: BodyColor):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented("Resolver", "unresolve_body")
