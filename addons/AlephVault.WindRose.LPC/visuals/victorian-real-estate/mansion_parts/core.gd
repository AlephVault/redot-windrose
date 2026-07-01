extends Object

const SOURCE_TEXTURE := preload("res://addons/AlephVault.WindRose.LPC/images/victorian-decoration/mansion.png")

## The size of the blocks to render.
const BLOCK_SIZE: int = 96

## The extra, vertical, size to use for extra assets like door frames or stairs.
const EXTRA_SIZE: int = 16

## The offset, expressed in blocks, to apply. The minimum is 2 blocks.
const BASE_OFFSET_IN_BLOCKS: int = 2

## The color for the roof.
enum RoofColor {
	PURPLE, GRAY, BLUE, GREEN, RED, BROWN, WHITE, BLACK, WORN_RED, WORN_GREEN
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

## Computes the dimensions to use for the texture. It's based on its depth, stories and design.
static func compute_size(stories: Stories, depth: Depth, design: Design) -> Vector2i:
	var x_blocks: int = 0
	var y_blocks: int = 0
	var uses_extra: bool = false

	# Compute the base size of the mansion, in terms of blocks used by the
	# design in the smallest configuration.
	match design:
		Depth.LINE_SHAPE:
			x_blocks = 3
			y_blocks = 3
			uses_extra = true
		Depth.T_SHAPE:
			x_blocks = 3
			y_blocks = 4
			uses_extra = true
		Depth.LITTLE_C_SHAPE:
			x_blocks = 3
			y_blocks = 4
		Depth.BIG_C_SHAPE:
			x_blocks = 5
			y_blocks = 4
		Depth.E_SHAPE:
			x_blocks = 5
			y_blocks = 3
			uses_extra = true

	# Add Y size based on depth and stories.
	y_blocks += int(depth) + int(stories)

	# Compute the final size, in pixels.
	var x: int = x_blocks * BLOCK_SIZE
	var y: int = y_blocks * BLOCK_SIZE
	if uses_extra:
		y += EXTRA_SIZE

	# Return the size.
	return Vector2i(x, y)
