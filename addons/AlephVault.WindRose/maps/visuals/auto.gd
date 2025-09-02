extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual
## This MapEntityVisual in particular relates to its own
## provider. This provider is the responsible of updating
## the image to use, by using the current delta and entity.
## The change is done in-place in this (Sprite2D) object.

## A provider is a stateful sprite updater which properly
## sets the current data of the image to show, based on
## custom (interchangeable) logic.
class Provider:
	
	## Returns the image (perhaps keeping a same image for
	## certain amount of time).
	func update(
		s: Sprite2D, e: AlephVault__WindRose.Maps.MapEntity,
		delta: float
	):
		AlephVault__WindRose.Utils.AccessUtils.not_implemented(
			"Provider", "update"
		)

## An image setup for a Sprite2D object. This setup tells
## the following features:
## 1. The image.
## 2. The rect for the image (optional).
## 3. The number of vertical frames.
## 4. The number of horizontal frames.
class SimpleProviderSetup:
	
	# The underlying image.
	var _image: Texture2D
	
	## The underlying image.
	var image: Texture2D:
		get:
			return _image
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"SimpleProviderSetup", "image"
			)
	
	# The underlying region.
	var _region: Rect2i
	
	## The underlying region.
	var region: Rect2i:
		get:
			return _region
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"SimpleProviderSetup", "region"
			)
	
	# The amount of frames (linearly distributed).
	var _n_frames: int

	## The amount of frames (linearly distributed).
	var n_frames: int:
		get:
			return _n_frames
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"SimpleProviderSetup", "n_frames"
			)
	
	# Whether the frames are vertically or horizontally
	# distributed in the image.
	var _vertically_distributed: bool
	
	## Whether the frames are vertically or horizontally
	## distributed in the image.
	var vertically_distributed: bool:
		get:
			return _vertically_distributed
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"SimpleProviderSetup", "n_frames"
			)

	func _init(
		image: Texture2D, region: Rect2i, n_frames: int,
		vertically_distributed: bool
	):
		if image == null:
			region = Rect2i(0, 0, 0, 0)
		elif region.position.x < 0 or region.position.y < 0 or \
			 region.size.x < 1 or region.size.y < 1:
			region = Rect2i(Vector2i.ZERO, image.get_size())
		self._image = image
		self._region = region
		n_frames = max(1, n_frames)
		self._n_frames = n_frames
		self._vertically_distributed = vertically_distributed

	## Applies this setup into a sprite for the
	func apply(sprite: Sprite2D, frame: int):
		if self._image == null:
			sprite.texture = null
		else:
			if sprite.texture != image:
				sprite.texture = image
			sprite.region_enabled = true
			sprite.region_filter_clip_enabled = true
			sprite.region_rect = region
			if self._vertically_distributed:
				sprite.vframes = n_frames
				sprite.hframes = 1
			else:
				sprite.vframes = 1
				sprite.hframes = n_frames
			sprite.frame = frame % n_frames
