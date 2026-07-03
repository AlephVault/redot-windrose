extends Object

const _Step := AlephVault__WindRose.Utils.Textures.Step
const _Context := AlephVault__WindRose.Utils.Textures.Context

## The source texture.
const SOURCE_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/victorian-decoration/mansion.png")

## The size of the blocks to render.
const BLOCK_SIZE: int = 96

## The extra, vertical, size to use for extra assets like door frames or stairs.
const EXTRA_SIZE: int = 16

## The offset, expressed in blocks, to apply. The minimum is 2 blocks.
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
	var x: int = blocks.x * BLOCK_SIZE
	var y: int = blocks.y * BLOCK_SIZE
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
	var y: int = 2 + int(depth) + index
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
