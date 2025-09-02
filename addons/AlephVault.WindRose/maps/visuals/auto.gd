extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual
## This MapEntityVisual in particular relates to its own
## provider. This provider is the responsible of updating
## the image to use, by using the current delta and entity.
## The change is done in-place in this (Sprite2D) object.

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction

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
class FramesetSetup:
	
	# The underlying image. This one can be changed
	# on the fly if needed.
	var image: Texture2D
	
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
		self.image = image
		self._region = region
		n_frames = max(1, n_frames)
		self._n_frames = n_frames
		self._vertically_distributed = vertically_distributed

	## Applies this setup into a sprite for the chosen frame.
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

## A setup for a single state, which can involve
## one single frameset or multiple framesets, one
## for each direction.
class StateSetup:
	
	var _up: FramesetSetup
	
	## The up-facing frameset. Optional.
	var up: FramesetSetup:
		get:
			return _up
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"StateSetup", "up"
			)
	
	var _down: FramesetSetup

	## The down-facing frameset, or the default
	## frameset if no other orientations are used.
	var down: FramesetSetup:
		get:
			return _down
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"StateSetup", "down"
			)
	
	var _left: FramesetSetup
	
	## The left-facing frameset. Optional.
	var left: FramesetSetup:
		get:
			return _left
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"StateSetup", "left"
			)

	var _right: FramesetSetup

	## The right-facing frameset. Optional.
	var right: FramesetSetup:
		get:
			return _right
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"StateSetup", "right"
			)
	
	func _init(
		down: FramesetSetup, up: FramesetSetup = null,
		left: FramesetSetup = null, right: FramesetSetup = null
	):
		if not is_instance_valid(down):
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"invalid_frameset", "The first argument must be a valid frameset"
			)
		_down = down
		if left != null and right != null and up == null:
			_up = up
			_left = left
			_right = right

	## Applies a direction-dependent setup into a sprite for
	## the chosen frame. If only the down direction is set,
	## then it applies it regardless the direction.
	func apply(sprite: Sprite2D, direction: _Direction, frame: int):
		var frameset_setup: FramesetSetup = null
		match direction:
			_Direction.UP:
				frameset_setup = _up if _up != null else _down
			_Direction.DOWN:
				frameset_setup = _down
			_Direction.LEFT:
				frameset_setup = _left if _left != null else _down
			_Direction.RIGHT:
				frameset_setup = _right if _right != null else _down
		if not is_instance_valid(frameset_setup):
			sprite.image = null
		else:
			frameset_setup.apply(sprite, frame)

## A setup for multiple states. A first setup is specified
## for the default state (empty string, ""), and then a
## dictionary mapping [state: String] => (setup: StateSetup).
class FullSetup:
	
	# The default state setup, for key "".
	var _default_state: StateSetup
	
	## The default state setup, for key "".
	var default_state: StateSetup:
		get:
			return _default_state
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"FullSetup", "default_state"
			)
	
	# The available non-default states.
	var _states: Dictionary
	
	## Retrieves one of the states. If it is not
	## available (non-existing key), then returns
	## the default state.
	func get_state(key: String) -> StateSetup:
		return _states.get(key, _default_state)
	
	func _init(default_setup: StateSetup, custom_states: Dictionary = {}):
		custom_states = custom_states.duplicate()
		if not is_instance_valid(default_setup):
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"invalid_state", "The first argument must be a valid state"
			)
		else:
			_default_state = default_state
		for key in custom_states.keys():
			if key == "":
				custom_states.erase("")
				push_warning(
					"The custom_states cannot contain an entry for the empty " +
					"string, since the empty string is used for the default " +
					"state. The entry will be removed"
				)
			var value = custom_states[key]
			if not (is_instance_valid(value) and value is StateSetup):
				custom_states.erase(key)
				push_warning(
					"The custom_states has, at key: " + key + ", an object " +
					"which is either not a valid instance or not an instance " +
					"of StateSetup. The entry will be removed"
				)
		_states = custom_states

	## Applies a state-dependent setup into a sprite for
	## the chosen frame. If only the down direction is set,
	## then it applies it regardless the direction.
	func apply(sprite: Sprite2D, state_key: String, direction: _Direction, frame: int):
		var state = get_state(state_key)
		if is_instance_valid(state):
			state.apply(sprite, direction, frame)
		else:
			state.image = null
