extends AlephVault__WindRose.Maps.Visuals.AutoMapEntityVisual
## Movable map entity visuals are visuals which are intended
## to move (and to change any details when moving). They are
## children of the AutoMapEntityVisual in the way they make
## a proper setup of their animations.
##
## This class can be picked out of the box to attach it to any
## visual being for a static object (e.g. a tree, a boulder,
## or some kind of street sign), then setting up the following
## properties according to these details:
##
## - texture: Can be set on editor, as always. Trying to set this
##   at runtime will be silently ignored and overridden. Another
##   technique will be described here.
## - centered & offset: Can be set on editor, as always. Like for
##   the texture properties, trying to set these at runtime will
##   be silently ignored and overridden.
## - flip_h & flip_v: Can be set on editor, as always. Can be
##   changed at runtime.
## - hframes, vframes: Depending on the Vertically Distributed
##   properties, these will be paid attention to at editor time:
##   if true, then vframes will be considered and hframes will
##   be forced to 1, while if false, then hframes will be
##   considered and vframes will be forced to 1.
## - frame and frame_coords: Setting them at editor time will be
##   pointless, since they'll be overridden at runtime.
## - region_rect: Can be set at editor, as always. Trying to set
##   it at runtime will be silently ignored and overridden.
## - region_enabled and filter_clip_enabled: Setting them at
##   editor time will be pointless, since they'll be overridden
##   at runtime.
##
## This means that only texture, centered & offset, flip_h / flip_v
## and region_rect are meaningful here.
##
## There are also three extra region_rect-related properties:
## region_rect_up, region_rect_left and region_rect_right. If these
## (all) are set (i.e. a position (x>=0, y>=0) and a size (x>0, y>0)),
## then region_rect will stand for down-looking animation and each of
## the four fields will be used to reflect when the object looks at
## different directions via its orientation property. Otherwise,
## this visual will always show the same image or animation when the
## owning object changes its orientation.
##
## This setup corresponds to the animation for when the object
## is moving, a priori. The same setup will be used for when the
## object is idle (WARNING: this account for state=IDLE and MOVING,
## while custom states will fail / not trigger), but for the idle
## state only one frame (the first frame, each time) will be taken.
##
## At runtime, there is a new property:
##
## - full_setup: AlephVault__WindRose.Maps.Visuals.AutoMapEntityVisual.FullSetup:
##   Holds the entire visual setup for this object, as described in the Auto-
##   visual class.

## Whether the frames are distributed vertically or not (i.e. horizontally)
## inside the image (either the full image size or using one or more region
## rectangles). The number of frames to pay attention for, when generating
## these animations, will come from the vframes or hframes property (this
## depends on whether this property is true or false).
@export var _vertically_distributed: bool = true

## The rectangle where the up-facing frames are located.
@export var _region_rect_up: Rect2 = Rect2(0, 0, 0, 0)

## The rectangle where the left-facing frames are located.
@export var _region_rect_left: Rect2 = Rect2(0, 0, 0, 0)

## The rectangle where the right-facing frames are located.
@export var _region_rect_right: Rect2 = Rect2(0, 0, 0, 0)

func __valid_region_rect(rect: Rect2) -> bool:
	return rect.position.x >= 0 and rect.position.y >= 0 and \
		   rect.size.x > 0 and rect.size.y > 0

# Creates the full setup.
func _make_full_setup() -> FullSetup:
	return FullSetup.new(
		StateSetup.new(
			FramesetSetup.new(
				texture, _region_rect_up, 1,
				_vertically_distributed, centered, offset
			) if __valid_region_rect(_region_rect_up) else null,
			FramesetSetup.new(
				texture, region_rect, 1,
				_vertically_distributed, centered, offset
			),
			FramesetSetup.new(
				texture, _region_rect_left, 1,
				_vertically_distributed, centered, offset
			) if __valid_region_rect(_region_rect_left) else null,
			FramesetSetup.new(
				texture, _region_rect_right, 1,
				_vertically_distributed, centered, offset
			) if __valid_region_rect(_region_rect_right) else null,
		),
		{
			AlephVault__WindRose.Maps.MapEntity.STATE_MOVING: StateSetup.new(
				FramesetSetup.new(
					texture, _region_rect_up, vframes if _vertically_distributed else hframes,
					_vertically_distributed, centered, offset
				) if __valid_region_rect(_region_rect_up) else null,
				FramesetSetup.new(
					texture, region_rect, vframes if _vertically_distributed else hframes,
					_vertically_distributed, centered, offset
				),
				FramesetSetup.new(
					texture, _region_rect_left, vframes if _vertically_distributed else hframes,
					_vertically_distributed, centered, offset
				) if __valid_region_rect(_region_rect_left) else null,
				FramesetSetup.new(
					texture, _region_rect_right, vframes if _vertically_distributed else hframes,
					_vertically_distributed, centered, offset
				) if __valid_region_rect(_region_rect_right) else null,
			)
		}
	)
