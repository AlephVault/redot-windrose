@tool
extends AlephVault__WindRose__LPC.Visuals.VictorianRealEstate.Base
## This asset assembles and represents a victorian-themed mansion
## to be used in games, for a decent diversity of styles.

## The color to paint the walls of.
enum WallColor {
	YELLOW, RED, GREEN, GRAYBLUE, BLUE, PURPLE
}

## The color to paint the walls of.
var wall_color: WallColor = WallColor.YELLOW:
	set(value):
		wall_color = value
		_refresh_texture()

## The color for the windows. This includes the possibility for a
## window to reflect a CLASSIC type (the color is white and the
## curtains match the color of the walls).
enum WindowColor {
	CLASSIC, BLACK, WHITE, YELLOW, RED, GREEN, BROWN
}

## The color for the windows.
var window_color: WindowColor = WindowColor.CLASSIC:
	set(value):
		window_color = value
		_refresh_texture()

## The color for the roof.
enum RoofColor {
	PURPLE, GRAY, BLUE, GREEN, RED, BROWN, WHITE, BLACK, WORN_RED, WORN_GREEN
}

var roof_color: RoofColor = RoofColor.PURPLE:
	set(value):
		roof_color = value
		_refresh_texture()

## The size type for the doors.
enum DoorSizeType {
	NORMAL, LARGE
}

## The size type for the doors.
var door_size_type: DoorSizeType = DoorSizeType.NORMAL:
	set(value):
		door_size_type = value
		_refresh_texture()

const _N_NORMAL_DOORS = 50
const _N_LARGE_DOORS = 21

## The door index. There are 50 normal doors, and
## 21 large doors (3 doors, 7 colors).
var door_type: int = 0:
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

## Applies all the texture's update.
func _refresh_texture():
	pass
