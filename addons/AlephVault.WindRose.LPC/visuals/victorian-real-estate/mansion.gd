@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianRealEstate.Base
## This asset assembles and represents a victorian-themed mansion
## to be used in games, for a decent diversity of styles.

## The color to paint the walls of.
enum WallColor {
	YELLOW, RED, GREEN, GRAYBLUE, BLUE, PURPLE
}

## The color for the windows. This includes the possibility for a
## window to reflect a CLASSIC type (the color is white and the
## curtains match the color of the walls).
enum WindowColor {
	CLASSIC, BLACK, WHITE, YELLOW, RED, GREEN, BROWN
}

## The color for the roof.
enum RoofColor {
	PURPLE, GRAY, BLUE, GREEN, RED, BROWN, WHITE, BLACK, WORN_RED, WORN_GREEN
}

## The size type for the doors.
enum DoorSizeType {
	NORMAL, LARGE
}

## The color for the door stairs. Please note that it
## is different to the color for the bricks and roof.
enum DoorstepsColor {
	GRAY_LIGHT,
	GRAY_DARK,
	BLUE_LIGHT,
	BLUE_MID_LIGHT,
	BLUE_MID,
	BLUE_MID_DARK,
	BLUE_DARK
}

## The color for the doorframe.
enum DoorframeColor {
	ORANGE_LIGHT,
	ORANGE_MID,
	ORANGE_DARK,
	BROWN_LIGHT,
	BROWN_MID,
	BROWN_DARK,
	GRAY_LIGHT,
	GRAY_MID,
	GRAY_DARK
}

## The color to paint the walls of.
@export var wall_color: WallColor = WallColor.YELLOW:
	set(value):
		wall_color = value
		_refresh_texture()

## The color for the windows.
@export var window_color: WindowColor = WindowColor.CLASSIC:
	set(value):
		window_color = value
		_refresh_texture()

## The color for the roof.
@export var roof_color: RoofColor = RoofColor.PURPLE:
	set(value):
		roof_color = value
		_refresh_texture()

## The size type for the doors.
@export var door_size_type: DoorSizeType = DoorSizeType.NORMAL:
	set(value):
		door_size_type = value
		if door_size_type == DoorSizeType.NORMAL:
			if door_type >= _N_NORMAL_DOORS:
				door_type = 0
		else:
			if door_type >= _N_LARGE_DOORS:
				door_type = 0
		_refresh_texture()

const _N_NORMAL_DOORS = 50
const _N_LARGE_DOORS = 21
const _N_DOORFRAMES = 7

## The door index. There are 50 normal doors, and
## 21 large doors (3 doors, 7 colors).
@export var door_type: int = 0:
	set(value):
		if value < 0:
			value = 0
		if door_size_type == DoorSizeType.NORMAL:
			if value >= _N_NORMAL_DOORS:
				value = 0
		else:
			if value >= _N_LARGE_DOORS:
				value = 0
		_refresh_texture()

## The color for the door steps.
@export var doorsteps_color: DoorstepsColor = DoorstepsColor.GRAY_LIGHT:
	set(value):
		doorsteps_color = value
		_refresh_texture()

## Whether it has a doorframe or not. This is not used for
## large door styles.
@export var has_doorframe: bool = false:
	set(value):
		has_doorframe = value
		_refresh_texture()

## The color for the doorframe.
@export var doorframe_color: DoorframeColor = DoorframeColor.GRAY_LIGHT:
	set(value):
		doorframe_color = value
		_refresh_texture()

## The type for the doorframe.
@export var doorframe_type: int = 0:
	set(value):
		doorframe_type = value
		if doorframe_type < 0:
			doorframe_type = 0
		if doorframe_type >= _N_DOORFRAMES:
			doorframe_type = _N_DOORFRAMES
		_refresh_texture()

# TODO add:
# - Window index for even blocks (0-15 if color or 0-1 if classic).
# - Window index for odd blocks (0-15 if color or 0-1 if classic).
# - Whether using bricked design or not.
# - Whether it has 1 or 2 floors/levels/stories.
# - Layout (_, T, c, C or E).
# - Whether the first level in modes c, C or E use box windows or not.
#   Classic color will use only one style. Regular colors have also one style.
# - Whether to use columns in the first-level, odd blocks (non-middle) or not.
# - Light mode: Daylight, Night (lights turned off), Night (lights turned on).
## Applies all the texture's update.
func _refresh_texture():
	pass
