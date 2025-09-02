extends AlephVault__WindRose.Maps.Layers.Layer
## This is a visuals layer. It will have the visual
## elements related to each MapEntity object in the
## map it belongs to.

## A sub-layer for this visuals layer.
class SubLayer extends Node2D:
	pass

# The initialized sub-layers of this layer.
var _sub_layers: Array[SubLayer] = []

# The callback to get the effective level for the
# coordinates of the entity.
var _get_level: Callable

# The callback to get the effective sub-level for
# the coordinates of the entity and the current
# level computed in the other callback.
var _get_sub_level: Callable

# Pre-condition: By this point, the layer is fully
# initialized so the _sub_layers exist.
func _fix_level(v: VisualsContainer):
	var l: int = _get_level.call(v._map_entity)
	var l_: int = _get_sub_level.call(l, v._map_entity)
	v.reparent(_sub_layers[l])
	v.z_index = l_

## A container related to a MapEntity and container
## of its children of type MapEntityVisual.
class VisualsContainer extends Node2D:
	var _map_entity: AlephVault__WindRose.Maps.MapEntity
	var _paused: bool = false
	
	func _process(delta):
		if _map_entity != null:
			global_position = _map_entity.global_position
	
	## Pauses this object's visual animation
	## by pausing children's visual animations.
	func pause():
		_paused = true
		for child in get_children():
			if child is AlephVault__WindRose.Maps.MapEntityVisual:
				child.pause()
	
	## Resumes this object's visual animation
	## by resuming children's visual animations.
	func resume():
		_paused = false
		for child in get_children():
			if child is AlephVault__WindRose.Maps.MapEntityVisual:
				child.resume()
	
	## Updates a single frame of animation.
	func update(delta: float):
		if _paused:
			return

		for child in get_children():
			if child is AlephVault__WindRose.Maps.MapEntityVisual:
				child.update(delta)
	
	## Binds this object to a new entity.
	func bind_entity(e: AlephVault__WindRose.Maps.MapEntity):
		if not is_instance_valid(e) or is_instance_valid(_map_entity):
			return
		var map: AlephVault__WindRose.Maps.Map = e.current_map
		if not is_instance_valid(map):
			return
		var layer: AlephVault__WindRose.Maps.Layers.VisualsLayer = map.visuals_layer
		if not is_instance_valid(layer):
			return
		
		var s = self
		var on_movement_finished: Callable = func(
			from_position: Vector2i, to_position: Vector2i,
			direction: AlephVault__WindRose.Utils.DirectionUtils.Direction
		):
			layer._fix_level(s)
		var on_teleported: Callable = func(
			from_position: Vector2i, to_position: Vector2i
		):
			layer._fix_level(s)
		var on_exit_tree: Callable
		on_exit_tree = func():
			# Reparent the children of this object to the
			# parent entity. Then, destroy this object.
			# Also, disconnect this callback.
			if is_instance_valid(e):
				for c in get_children():
					if c is AlephVault__WindRose.Maps.MapEntityVisual:
						c.reparent(e)
						c.visible = false
			else:
				for c in get_children():
					if c is AlephVault__WindRose.Maps.MapEntityVisual:
						c.queue_free()
			e.tree_exiting.disconnect(on_exit_tree)
			e.rule.signals.on_movement_finished.disconnect(on_movement_finished)
			e.rule.signals.on_teleported.disconnect(on_teleported)
			_map_entity = null
			s.queue_free()

		# Connect the tree_exiting, on_movement_finished and on_teleported callbacks.
		e.tree_exiting.connect(on_exit_tree)
		e.rule.signals.on_teleported.connect(on_teleported)
		e.rule.signals.on_movement_finished.connect(on_movement_finished)
		# Assign the proper entity.
		_map_entity = e
		if e.paused:
			pause()
		else:
			resume()
		# Also, grab the entity's children and put them
		# right here.
		for c in e.get_children():
			if c is AlephVault__WindRose.Maps.MapEntityVisual:
				c.reparent(s)
				c.visible = true
				c.setup(e)
		# Finally, set this object to the proper position.
		layer._fix_level(self)

# Whether it's initialized or not.
var _initialized: bool = false

## Whether it's initialized or not.
var initialized: bool:
	get:
		return _initialized
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"VisualsLayer", "initialized"
		)

## Initializes this visuals layer (e.g. the size
## and sub-layers associated to this visuals layer
## and the proper amount of levels).
func initialize():
	if not _map:
		return
	
	if not _initialized:
		if _map.layout.layout_type == _map._MapLayoutType.INVALID:
			return
		_initialized = true
		var L: int = 0
		var l: Callable
		# var L_: Callable
		var l_: Callable
		match _map.layout.layout_type:
			_map._MapLayoutType.ORTHOGONAL:
				L = _map.size.y
				l = func(e):
					return e.cell.y
				# L_ = func(for_l):
				# 	return _map.size.x
				l_ = func(for_l, e):
					return e.cell.x
			_map._MapLayoutType.ISOMETRIC_TOPDOWN:
				L = _map.size.x + _map.size.y - 1
				l = func(e):
					return e.cell.x + e.cell.y
				# L_ = func(for_l):
				# 	return min(for_l, L - 1 - for_l, _map.size.x, _map.size.y)
				l_ = func(for_l, e):
					return min(e.cell.x, _map.size.y - 1 - e.cell.y)
			_map._MapLayoutType.ISOMETRIC_LEFTRIGHT:
				L = _map.size.x + _map.size.y - 1
				l = func(e):
					return e.cell.y - e.cell.x + _map.size.x
				# L_ = func(for_l):
				# 	return min(for_l, L - 1 - for_l, _map.size.x, _map.size.y)
				l_ = func(for_l, e):
					return min(e.cell.x, e.cell.y)
		_get_level = l
		_get_sub_level = l_
		_sub_layers.clear()
		var pivot: int = min(0, 4096 - L)
		for index in range(L):
			var node = SubLayer.new()
			node.name = "SubLevel-" + str(index)
			node.position = Vector2(0, 0)
			node.z_index = pivot + index
			_sub_layers.append(node)
			add_child(node)

## We leave the _z_index in 50 here, explicitly.
## We leave space for few layers under the feet
## of the characters.
func _z_index() -> int:
	return 50
