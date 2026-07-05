extends Object

const _Step := AlephVault__WindRose.Utils.Textures.Step
const _Context := AlephVault__WindRose.Utils.Textures.Context

## The source texture.
const SOURCE_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/victorian-decoration/mansion.png")

## The size of the blocks to render.
const BLOCK_SIZE: int = 96

## The size of the shadow, when used.
const SHADOW_SIZE: int = 96

## The extra, vertical, size to use for extra assets like door frames or stairs.
const EXTRA_SIZE: int = 16

## The offset, expressed in blocks, to apply. The minimum is 2 blocks.
## This is, actually, the size of the roof rendering when the depth is
## 1 block.
const BASE_OFFSET_IN_BLOCKS: int = 2

## The pivot point for the roof.
const ROOF_PIVOT = Vector2i(0, 1408)

## The amount of blocks in the x axis for a single roof's palette.
const ROOF_PALETTE_X_BLOCKS = 3

## The amount of blocks in the y axis for a single roof's palette.
const ROOF_PALETTE_Y_BLOCKS = 5

## The size, in pixels, for a single roof's palette.
const ROOF_PALETTE_SIZE = Vector2i(ROOF_PALETTE_X_BLOCKS * BLOCK_SIZE, ROOF_PALETTE_Y_BLOCKS * BLOCK_SIZE)

## The color for the roof.
enum RoofColor {
	PURPLE, GRAY, BLUE, GREEN, RED, BROWN, WHITE, BLACK, WORN_RED, WORN_GREEN
}

## The color for the wall.
enum WallColor {
	YELLOW, RED, GREEN, GRAYBLUE, BLUE, PURPLE
}

## The design of the house.
enum Design {
	LINE_SHAPE, T_SHAPE, LITTLE_C_SHAPE, BIG_C_SHAPE, E_SHAPE
}

## The stories (either one or two).
enum Stories {
	SINGLE, DOUBLE
}

## The depth (either single or double).
enum Depth {
	SINGLE, DOUBLE
}

## The light mode (daylight, night with lights off, night with light on).
enum LightMode {
	DAY, NIGHT_OFF, NIGHT_ON
}

## The style/color for windows (classic vs. colored).
enum WindowColor {
	CLASSIC, BLACK, WHITE, YELLOW, RED, GREEN, BROWN
}

## The doorframe color.
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

## The color of the door stairs
enum DoorstepsColor {
	GRAY_LIGHT,
	GRAY_DARK,
	BLUE_LIGHT,
	BLUE_MID_LIGHT,
	BLUE_MID,
	BLUE_MID_DARK,
	BLUE_DARK
}

## The shape of the door (rectangular, rounded, large-rounded)
enum DoorShape {
	RECTANGULAR,
	ROUNDED,
	ROUNDED_LARGE
}

# Door style index, Window style index, and Doorframe Index
# are all integer values and the logic will be determined
# later in this code.

## Computes the offset to use for the texture. It's based on its stories.
static func compute_offset(stories: Stories) -> Vector2i:
	var offset: int = (int(stories) + BASE_OFFSET_IN_BLOCKS) * BLOCK_SIZE
	return Vector2i(0, -offset)

## Tells whether a design uses extra space or not.
static func design_uses_extra_space(design: Design) -> bool:
	return design != Design.LITTLE_C_SHAPE and Design.BIG_C_SHAPE 

## Computes the size of a design, expressed in blocks.
static func compute_block_size(design: Design) -> Vector2i:
	match design:
		Design.LINE_SHAPE:
			return Vector2i(3, 3)
		Design.T_SHAPE:
			return Vector2i(3, 4)
		Design.LITTLE_C_SHAPE:
			return Vector2i(3, 4)
		Design.BIG_C_SHAPE:
			return Vector2i(5, 4)
		Design.E_SHAPE:
			return Vector2i(5, 4)
	return Vector2i(0, 0)

## Computes the dimensions to use for the texture. It's based on its depth, stories and design.
static func compute_size(stories: Stories, depth: Depth, design: Design) -> Vector2i:
	var uses_extra: bool = design_uses_extra_space(design)
	var blocks: Vector2i = compute_block_size(design)

	# Add Y size based on depth and stories.
	blocks.y += int(depth) + int(stories)

	# Compute the final size, in pixels.
	# This also involves adding the shadow and the extra height.
	var x: int = blocks.x * BLOCK_SIZE
	var y: int = blocks.y * BLOCK_SIZE
	x += SHADOW_SIZE
	if uses_extra:
		y += EXTRA_SIZE

	# Return the size.
	return Vector2i(x, y)

# Computes the base position of the roof to apply.
static func _get_roof_base_position(roof_color: RoofColor) -> Vector2i:
	var pos: Vector2i
	match roof_color:
		RoofColor.PURPLE:
			pos = Vector2i(0, 0)
		RoofColor.GRAY:
			pos = Vector2i(0, 1)
		RoofColor.BLUE:
			pos = Vector2i(0, 2)
		RoofColor.GREEN:
			pos = Vector2i(0, 3)
		RoofColor.RED:
			pos = Vector2i(0, 4)
		RoofColor.BROWN:
			pos = Vector2i(1, 0)
		RoofColor.WHITE:
			pos = Vector2i(1, 1)
		RoofColor.BLACK:
			pos = Vector2i(1, 2)
		RoofColor.WORN_RED:
			pos = Vector2i(1, 3)
		RoofColor.WORN_GREEN:
			pos = Vector2i(1, 4)
	return Vector2i(pos.x * ROOF_PALETTE_SIZE.x, pos.y * ROOF_PALETTE_SIZE.y) + ROOF_PIVOT

## Makes a step, configured from the current texture.
static func make_step(part: String, source_rect: Rect2i, target_position: Vector2i = Vector2i.ZERO) -> _Step:
	return _Step.new(part, SOURCE_TEXTURE, source_rect, target_position)

## Makes a block-aligned position.
static func block_position(pos: Vector2i) -> Vector2i:
	return Vector2i(pos.x * BLOCK_SIZE, pos.y * BLOCK_SIZE)

## Makes a rect for a block.
static func block_rect(pos: Vector2i) -> Rect2i:
	return Rect2i(pos.x * BLOCK_SIZE, pos.y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)

## Makes a step, configured from the current texture.
static func make_block_step(part: String, source_position: Vector2i, target_position: Vector2i = Vector2i.ZERO) -> _Step:
	return make_step(part, block_rect(source_position), block_position(target_position))

## Creates the steps related to base / background walls.
static func make_base_wall_steps(
	wall_color: WallColor, stories: Stories, depth: Depth, design: Design
) -> Array[_Step]:
	# First, depending on the depth, the y coordinate will
	# relate to 2 or 3 blocks.
	var y: int = BLOCK_SIZE * (BASE_OFFSET_IN_BLOCKS + int(depth))

	# Then, get the coordinates for the wall color.
	var wall_color_pivot: Vector2i = Vector2i(0, 192 * int(wall_color))

	# Then, depending on the design, the x coordinates will
	# span: 3 blocks (Line, T), 1 block and parts (Little C),
	# or 3 blocks and parts (Big C, E).
	var result: Array[_Step] = []
	match Design:
		Design.LINE_SHAPE, Design.T_SHAPE:
			for floor_ in range(stories):
				var y_: int = y + floor_ * BASE_OFFSET_IN_BLOCKS
				# Step 1: First chunk (+96, +96, 32, 96) -> (0, y_)
				# Step 2: Second chunk (+128, +96, 96, 96) -> (32, y_)
				# Step 3: Third chunk (+128, +96, 96, 96) -> (128, y_)
				# Step 4: Fourth chunk (+224, +96, 64, 96) -> (224, y_)
				result.append_array([
					make_step("wall-%d-floor-%d-part-1" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE, wall_color_pivot.y + BLOCK_SIZE,
						32, BLOCK_SIZE
					), Vector2i(0, y_)),
					make_step("wall-%d-floor-%d-part-2" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						BLOCK_SIZE, BLOCK_SIZE
					), Vector2i(32, y_)),
					make_step("wall-%d-floor-%d-part-3" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						BLOCK_SIZE, BLOCK_SIZE
					), Vector2i(32 + BLOCK_SIZE, y_)),
					make_step("wall-%d-floor-%d-part-4" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + 2 * BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						64, BLOCK_SIZE
					), Vector2i(32 + 2 * BLOCK_SIZE, y_)),
				])
		Design.LITTLE_C_SHAPE:
			for floor_ in range(stories):
				var y_: int = y + floor_ * BASE_OFFSET_IN_BLOCKS
				# Step 1: First chunk (+96, +96, 32, 96) -> (64, y_)
				# Step 2: Second chunk (+128, +96, 96, 96) -> (96, y_)
				# Step 3: Third chunk (+224, +96, 64, 96) -> (192, y_)
				result.append_array([
					make_step("wall-%d-floor-%d-part-1" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE, wall_color_pivot.y + BLOCK_SIZE,
						32, BLOCK_SIZE
					), Vector2i(64, y_)),
					make_step("wall-%d-floor-%d-part-2" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						BLOCK_SIZE, BLOCK_SIZE
					), Vector2i(BLOCK_SIZE, y_)),
					make_step("wall-%d-floor-%d-part-3" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + 2 * BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						64, BLOCK_SIZE
					), Vector2i(2 * BLOCK_SIZE, y_)),
				])
		Design.BIG_C_SHAPE, Design.E_SHAPE:
			for floor_ in range(stories):
				var y_: int = y + floor_ * BASE_OFFSET_IN_BLOCKS
				# Step 1: First chunk (+96, +96, 32, 96) -> (64, y_)
				# Step 2: Second chunk (+128, +96, 96, 96) -> (96, y_)
				# Step 3: Second chunk (+128, +96, 96, 96) -> (192, y_)
				# Step 4: Second chunk (+128, +96, 96, 96) -> (288, y_)
				# Step 5: Third chunk (+224, +96, 64, 96) -> (384, y_)
				result.append_array([
					make_step("wall-%d-floor-%d-part-1" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE, wall_color_pivot.y + BLOCK_SIZE,
						32, BLOCK_SIZE
					), Vector2i(64, y_)),
					make_step("wall-%d-floor-%d-part-2" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						BLOCK_SIZE, BLOCK_SIZE
					), Vector2i(BLOCK_SIZE, y_)),
					make_step("wall-%d-floor-%d-part-3" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						BLOCK_SIZE, BLOCK_SIZE
					), Vector2i(BLOCK_SIZE * 2, y_)),
					make_step("wall-%d-floor-%d-part-4" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						BLOCK_SIZE, BLOCK_SIZE
					), Vector2i(BLOCK_SIZE * 3, y_)),
					make_step("wall-%d-floor-%d-part-5" % [int(wall_color), stories - 1 - floor_], Rect2i(
						wall_color_pivot.x + 2 * BLOCK_SIZE + 32, wall_color_pivot.y + BLOCK_SIZE,
						64, BLOCK_SIZE
					), Vector2i(BLOCK_SIZE * 4, y_)),
				])

	return result

## Creates the steps to install the roof in the final texture
## that will, in the end, make the mansion.
static func make_roof_steps(
	roof_color: RoofColor, depth: Depth, design: Design
) -> Array[_Step]:
	var base_position: Vector2i = _get_roof_base_position(roof_color)
	match design:
		Design.LINE_SHAPE:
			match depth:
				Depth.SINGLE:
					# Design of roof:
					#
					# RRR
					# RRR
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(2, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 2), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(2, 2), Vector2i(2, 1)
						),
					]
				Depth.DOUBLE:
					# Design of roof:
					#
					# RRR
					# RRR
					# RRR
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(2, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 1), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 1), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(2, 1), Vector2i(2, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(0, 2), Vector2i(0, 2)
						),
						make_block_step(
							"roof-12-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 2)
						),
						make_block_step(
							"roof-22-" + str(roof_color),
							Vector2i(2, 2), Vector2i(2, 2)
						),
					]
		Design.T_SHAPE:
			match depth:
				Depth.SINGLE:
					# Design of roof:
					#
					# RRR
					# RRR
					#  R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(2, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 2), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 3), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(2, 2), Vector2i(2, 1)
						),
						make_block_step(
							"roof-12-" + str(roof_color),
							Vector2i(1, 4), Vector2i(1, 2)
						),
					]
				Depth.DOUBLE:
					# Design of roof:
					#
					# RRR
					# RRR
					# RRR
					#  R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(2, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 1), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 1), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(2, 1), Vector2i(2, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(0, 2), Vector2i(0, 2)
						),
						make_block_step(
							"roof-12-" + str(roof_color),
							Vector2i(1, 3), Vector2i(1, 2)
						),
						make_block_step(
							"roof-22-" + str(roof_color),
							Vector2i(2, 2), Vector2i(2, 2)
						),
						make_block_step(
							"roof-13-" + str(roof_color),
							Vector2i(1, 4), Vector2i(1, 3)
						),
					]
		Design.LITTLE_C_SHAPE:
			match depth:
				Depth.SINGLE:
					# Design of roof:
					#
					# RRR
					# RRR
					# R R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(2, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 3), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(2, 3), Vector2i(2, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(1, 4), Vector2i(0, 2)
						),
						make_block_step(
							"roof-22-" + str(roof_color),
							Vector2i(1, 4), Vector2i(2, 2)
						),
					]
				Depth.DOUBLE:
					# Design of roof:
					#
					# RRR
					# RRR
					# RRR
					# R R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(2, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 1), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 1), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(2, 1), Vector2i(2, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(0, 3), Vector2i(0, 2)
						),
						make_block_step(
							"roof-12-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 2)
						),
						make_block_step(
							"roof-22-" + str(roof_color),
							Vector2i(2, 3), Vector2i(2, 2)
						),
						make_block_step(
							"roof-03-" + str(roof_color),
							Vector2i(1, 4), Vector2i(0, 3)
						),
						make_block_step(
							"roof-23-" + str(roof_color),
							Vector2i(1, 4), Vector2i(2, 3)
						),
					]
		Design.BIG_C_SHAPE:
			match depth:
				Depth.SINGLE:
					# Design of roof:
					#
					# RRRRR
					# RRRRR
					# R   R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(1, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-30-" + str(roof_color),
							Vector2i(1, 0), Vector2i(3, 0)
						),
						make_block_step(
							"roof-40-" + str(roof_color),
							Vector2i(2, 0), Vector2i(4, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 3), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(1, 2), Vector2i(2, 1)
						),
						make_block_step(
							"roof-31-" + str(roof_color),
							Vector2i(1, 2), Vector2i(3, 1)
						),
						make_block_step(
							"roof-41-" + str(roof_color),
							Vector2i(2, 3), Vector2i(4, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(1, 4), Vector2i(0, 2)
						),
						make_block_step(
							"roof-42-" + str(roof_color),
							Vector2i(1, 4), Vector2i(4, 2)
						),
					]
				Depth.DOUBLE:
					# Design of roof:
					#
					# RRRRR
					# RRRRR
					# RRRRR
					# R   R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(1, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-30-" + str(roof_color),
							Vector2i(1, 0), Vector2i(3, 0)
						),
						make_block_step(
							"roof-40-" + str(roof_color),
							Vector2i(2, 0), Vector2i(4, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 1), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 1), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(1, 1), Vector2i(2, 1)
						),
						make_block_step(
							"roof-31-" + str(roof_color),
							Vector2i(1, 1), Vector2i(3, 1)
						),
						make_block_step(
							"roof-41-" + str(roof_color),
							Vector2i(2, 1), Vector2i(4, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(0, 3), Vector2i(0, 2)
						),
						make_block_step(
							"roof-12-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 2)
						),
						make_block_step(
							"roof-22-" + str(roof_color),
							Vector2i(1, 2), Vector2i(2, 2)
						),
						make_block_step(
							"roof-32-" + str(roof_color),
							Vector2i(1, 2), Vector2i(3, 2)
						),
						make_block_step(
							"roof-42-" + str(roof_color),
							Vector2i(2, 3), Vector2i(4, 2)
						),
						make_block_step(
							"roof-03-" + str(roof_color),
							Vector2i(1, 4), Vector2i(0, 3)
						),
						make_block_step(
							"roof-43-" + str(roof_color),
							Vector2i(1, 4), Vector2i(4, 3)
						),
					]
		Design.E_SHAPE:
			match depth:
				Depth.SINGLE:
					# Design of roof:
					#
					# RRRRR
					# RRRRR
					# R R R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(1, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-30-" + str(roof_color),
							Vector2i(1, 0), Vector2i(3, 0)
						),
						make_block_step(
							"roof-40-" + str(roof_color),
							Vector2i(2, 0), Vector2i(4, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 3), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(1, 3), Vector2i(2, 1)
						),
						make_block_step(
							"roof-31-" + str(roof_color),
							Vector2i(1, 2), Vector2i(3, 1)
						),
						make_block_step(
							"roof-41-" + str(roof_color),
							Vector2i(2, 3), Vector2i(4, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(1, 4), Vector2i(0, 2)
						),
						make_block_step(
							"roof-22-" + str(roof_color),
							Vector2i(1, 4), Vector2i(2, 2)
						),
						make_block_step(
							"roof-42-" + str(roof_color),
							Vector2i(1, 4), Vector2i(4, 2)
						),
					]
				Depth.DOUBLE:
					# Design of roof:
					#
					# RRRRR
					# RRRRR
					# RRRRR
					# R   R
					return [
						make_block_step(
							"roof-00-" + str(roof_color),
							Vector2i(0, 0), Vector2i(0, 0)
						),
						make_block_step(
							"roof-10-" + str(roof_color),
							Vector2i(1, 0), Vector2i(1, 0)
						),
						make_block_step(
							"roof-20-" + str(roof_color),
							Vector2i(1, 0), Vector2i(2, 0)
						),
						make_block_step(
							"roof-30-" + str(roof_color),
							Vector2i(1, 0), Vector2i(3, 0)
						),
						make_block_step(
							"roof-40-" + str(roof_color),
							Vector2i(2, 0), Vector2i(4, 0)
						),
						make_block_step(
							"roof-01-" + str(roof_color),
							Vector2i(0, 1), Vector2i(0, 1)
						),
						make_block_step(
							"roof-11-" + str(roof_color),
							Vector2i(1, 1), Vector2i(1, 1)
						),
						make_block_step(
							"roof-21-" + str(roof_color),
							Vector2i(1, 1), Vector2i(2, 1)
						),
						make_block_step(
							"roof-31-" + str(roof_color),
							Vector2i(1, 1), Vector2i(3, 1)
						),
						make_block_step(
							"roof-41-" + str(roof_color),
							Vector2i(2, 1), Vector2i(4, 1)
						),
						make_block_step(
							"roof-02-" + str(roof_color),
							Vector2i(0, 3), Vector2i(0, 2)
						),
						make_block_step(
							"roof-12-" + str(roof_color),
							Vector2i(1, 2), Vector2i(1, 2)
						),
						make_block_step(
							"roof-22-" + str(roof_color),
							Vector2i(1, 3), Vector2i(2, 2)
						),
						make_block_step(
							"roof-32-" + str(roof_color),
							Vector2i(1, 2), Vector2i(3, 2)
						),
						make_block_step(
							"roof-42-" + str(roof_color),
							Vector2i(2, 3), Vector2i(4, 2)
						),
						make_block_step(
							"roof-03-" + str(roof_color),
							Vector2i(1, 4), Vector2i(0, 3)
						),
						make_block_step(
							"roof-23-" + str(roof_color),
							Vector2i(1, 4), Vector2i(2, 3)
						),
						make_block_step(
							"roof-43-" + str(roof_color),
							Vector2i(1, 4), Vector2i(4, 3)
						),
					]

	return []

## Computes the coordinates for a wall. All the data is used, except
## for the stories, for the comparison. Instead, a reverse index is
## used for the floor, computed as (n_stories - 1 - floor).
static func compute_target_wall_coordinates(
	roof_color: RoofColor, depth: Depth, design: Design,
	x: int, index: int
) -> Vector2i:
	# First, fix index. It can be only 0 or 1.
	if index < 1:
		index = 0
	if index > 1:
		index = 1
	
	# Then, compute the base Y coordinate (in blocks).
	var y: int = BASE_OFFSET_IN_BLOCKS + int(depth) + index
	match design:
		Design.LINE_SHAPE:
			if x > 2:
				x = 2
		Design.T_SHAPE:
			if x > 2:
				x = 2
			if x == 1:
				y += 1
		Design.LITTLE_C_SHAPE:
			if x > 2:
				x = 2
			if x == 0 or x == 2:
				y += 1
		Design.BIG_C_SHAPE:
			if x > 4:
				x = 4
			if x == 0 or x == 4:
				y += 1
		Design.E_SHAPE:
			if x > 4:
				x = 4
			if x == 0 or x == 2 or x == 4:
				y += 1

	return block_position(Vector2i(x, y))

# Next, it's time to paint the extra elements of the walls:
# 1. Design.T_SHAPE adds a middle prong.
# 2. Design.LITTLE_C_SHAPE adds two side prongs.
# 3. Design.BIG_C_SHAPE adds two far prongs.
# 4. Design.E_SHAPE adds a middle prong and two far prongs.
# 5. A prong can have, in the 1st floor:
#    - Box windows.
#    - Regular windows.
#    - Columns.
# 6. In other floors, only regular windows.
# 7. Prongs can have a bricked theme (and this will apply to all floors).
# 8. Prongs will have a window (color + style; where style only is considered for regular windows).
# 9. Non-prongs will have a window (color + style).
# 10. Door frame can be set (shape + color).
# 11. Door must be set (shape + style).
# 12. Stairs color must be set.
# 13. Light mode must be set. This also tells whether shadows will be cast or not.

static func make_mansion_steps() -> Array[_Step]:
	var steps: Array[_Ste] = []
	return steps
