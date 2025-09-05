extends AlephVault__WindRose.Maps.Visuals.AutoMapEntityVisual
## Static map entity visuals are visuals which are not intended
## to move (or to change any details if moving at all). They
## are children of the AutoMapEntityVisual in the way they make
## a proper setup of their animations.
##
## This class can be picked out of the box to attach it to any
## visual being for a static object (e.g. a tree, a boulder,
## or some kind of street sign), then setting up the following
## properties:
##
## - texture: Can be set on editor, as always. Trying to set this
##   at runtime will be silently ignored and overridden. Another
##   technique will be described here.
## - centered & offset: Can be set on editor, as always. Like for
##   the texture properties, trying to set these at runtime will
##   be silently ignored and overridden.
## - flip_h & flip_v: Can be set on editor, as always. Can be
##   changed at runtime.
## - h_frames, v_frames, frame and frame_coords: Setting them at
##   editor time will be pointless, since they'll be overridden
##   at runtime.
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
## At runtime, there is a new property:
##
## - full_setup: AlephVault__WindRose.Maps.Visuals.AutoMapEntityVisual.FullSetup:
##   Holds the entire visual setup for this object, as described in the Auto-
##   visual class.
