extends AlephVault__WindRose.Maps.Visuals.MapEntityVisual
## This MapEntityVisual in particular relates to its own
## provider. This provider is the responsible of updating
## the image to use, by using the current delta and entity.
## The change is done in-place in this (Sprite2D) object.
##
## This class is complete on itself but not recommended
## to be used by itself. Instead, children classes would
## be created (as some sort of recipes) to ease the users
## at editor time.

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
	
	## The underlying image. This one can be changed
	## on the fly if needed.
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
	
	# Whether the reference point for the offset is centered
	# or not (left-top-based).
	var _centered: bool
	
	## Whether the reference point for the offset is centered
	## or not (left-top-based).
	var centered: bool:
		get:
			return _centered
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"SimpleProviderSetup", "centered"
			)
	
	# The offset to apply to the sprite.
	var _offset: Vector2i
	
	## The offset to apply to the sprite.
	var offset: Vector2i:
		get:
			return _offset
		set(value):
			AlephVault__WindRose.Utils.AccessUtils.cannot_set(
				"SimpleProviderSetup", "offset"
			)
	
	## Creating a FramesetSetup takes the
	## properties that have the same meaning
	## in the Sprite2D objects: image (matches:
	## texture), region: (matches: region_rect),
	## centered and offset. Also, n_frames and
	## vertically_distributed tells the allowed
	## frames to infer (how many and whether in
	## row or in column).
	func _init(
		image: Texture2D, region: Rect2i, n_frames: int,
		vertically_distributed: bool, centered: bool = true,
		offset: Vector2i = Vector2i(0, 0)
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
		self._offset = offset
		self._centered = centered

	## Applies this setup into a sprite for the chosen frame.
	## Returns the effective index of the applied frame.
	func apply(sprite: Sprite2D, frame: int) -> int:
		if self._image == null:
			sprite.texture = null
		else:
			if sprite.texture != image:
				sprite.texture = image
			sprite.centered = centered
			sprite.offset = offset
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
		return sprite.frame

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
	
	## Creating this frameset setup takes at least one
	## non-null FramesetSetup object and optionally 3
	## other FramesetSetup instances. In this latter
	## case, those will be used to differentiate the
	## visual aspects of the object looking left, right
	## or up (otherwise, the same down-facing aesthetic
	## will be used in either case).
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
	## then it applies it regardless the direction. Returns
	## the effective index of the applied frame.
	func apply(sprite: Sprite2D, direction: _Direction, frame: int) -> int:
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
			sprite.texture = null
			return 0
		else:
			return frameset_setup.apply(sprite, frame)
	
	## Sets the given image in all the internal framesets.
	func set_image(image: Texture2D):
		_down.image = image
		if _up:
			_up.image = image
		if _left:
			_left.image = image
		if _right:
			_right.image = image

const _STATE_IDLE = AlephVault__WindRose.Maps.MapEntity.STATE_IDLE

## A setup for multiple states. A first setup is specified
## for the default state (0, zero), and then a dictionary
## mapping [state: int] => (setup: StateSetup).
class FullSetup:
	
	# The default state setup, for key STATE_IDLE.
	var _default_state: StateSetup
	
	## The default state setup, for key STATE_IDLE.
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
	func get_state(key: int) -> StateSetup:
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
			if key == _STATE_IDLE:
				custom_states.erase(_STATE_IDLE)
				push_warning(
					"The custom_states cannot contain an entry for the state " +
					"o (STATE_IDLE), since the empty string is used for the " +
					"default state. The entry will be removed"
				)
			var value = custom_states[key]
			if not (is_instance_valid(value) and value is StateSetup):
				custom_states.erase(key)
				push_warning(
					"The custom_states has, at key: " + str(key) + ", an object " +
					"which is either not a valid instance or not an instance " +
					"of StateSetup. The entry will be removed"
				)
		_states = custom_states

	## Applies a state-dependent setup into a sprite for
	## the chosen frame. If only the down direction is set,
	## then it applies it regardless the direction. Returns
	## the effective index of the applied frame.
	func apply(
		sprite: Sprite2D, state_key: int, direction: _Direction, frame: int
	):
		var state = get_state(state_key)
		if is_instance_valid(state):
			return state.apply(sprite, direction, frame)
		else:
			sprite.texture = null
			return 0

## The assigned full setup. By setting this property, this
## visual becomes active and showing images depending on the
## current orientation and / or state of the owning entity.
var full_setup: FullSetup

# The current state.
var _state: int = _STATE_IDLE

# The current orientation.
var _orientation: _Direction = _Direction.DOWN

# The current frame.
var _frame: int = 0

func _on_state_changed(s: int):
	_state = s
	_frame = 0
	_apply()

func _on_orientation_changed(o: _Direction):
	_orientation = o
	_frame = 0
	_apply()

# Applies a current frame to this sprite, from current
# direction and current state.
func _apply():
	if is_instance_valid(full_setup):
		_frame = full_setup.apply(self, _state, _orientation, _frame)
		_frame += 1
	else:
		texture = null
		_frame = 0

func _setup():
	map_entity.on_state_changed.connect(_on_state_changed)
	map_entity.on_orientation.connect(_on_orientation_changed)
	_state = map_entity.state
	_orientation = map_entity.orientation
	_frame = 0
	_apply()

func _teardown():
	map_entity.on_state_changed.disconnect(_on_state_changed)
	map_entity.on_orientation_changed.disconnect(_on_orientation_changed)
	texture = null

func _update(delta: float):
	if is_instance_valid(full_setup):
		_apply()

## Sets the image for a given state. The state must exist.
func set_image(state: int, image: Texture2D):
	if not is_instance_valid(full_setup):
		AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
			"invalid_setup",
			"Cannot set the image for any state since the full setup is not " +
			"properly set"
		)
		return
	if state == _STATE_IDLE:
		full_setup.default_state.set_image(image)
	else:
		var state_setup = full_setup.get_state(state)
		if state_setup == full_setup.default_state:
			AlephVault__WindRose.Utils.ExceptionUtils.Exception.raise(
				"invalid_state", "The chosen state key is not set: " + str(state)
			)
			return
		state_setup.set_image(image)
