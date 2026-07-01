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

# Makes a step, configured from the current texture.
static func make_step(part: String, source_rect: Rect2i, target_position: Vector2i = Vector2i.ZERO) -> Object:
	return _Step.new(part, SOURCE_TEXTURE, source_rect, target_position)

## Creates the steps to install the roof in the final texture
## that will, in the end, make the mansion.
static func make_roof_steps(
	roof_color: RoofColor, design: Design, stories: Stories, depth: Depth
) -> Array[_Step]:
	var base_position: Vector2i = _get_roof_base_position(roof_color)
	match design:
		Depth.LINE_SHAPE:
			match stories:
				Stories.SINGLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
				Stories.DOUBLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
		Depth.T_SHAPE:
			match stories:
				Stories.SINGLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
				Stories.DOUBLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
		Depth.LITTLE_C_SHAPE:
			match stories:
				Stories.SINGLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
				Stories.DOUBLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
		Depth.BIG_C_SHAPE:
			match stories:
				Stories.SINGLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
				Stories.DOUBLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
		Depth.E_SHAPE:
			match stories:
				Stories.SINGLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]
				Stories.DOUBLE:
					match depth:
						Depth.SINGLE:
							return [
							]
						Depth.DOUBLE:
							return [
							]

	return []
