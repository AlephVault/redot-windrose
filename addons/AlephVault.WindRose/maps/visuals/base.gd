extends Sprite2D
## A map entity visual is an image that has a custom
## behaviour and is attached to an entity. Entities
## can have many of these objects as representations
## (e.g. character shapes, effects, overlays, ...).

func _process(delta):
	position = Vector2.ZERO

var _paused: bool

## Whether this visual is paused or not.
var paused: bool:
	get:
		return _paused
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntityVisual", "paused"
		)

var _map_entity: AlephVault__WindRose.Maps.MapEntity

## The current map entity.
var map_entity: AlephVault__WindRose.Maps.MapEntity:
	get:
		return _map_entity
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntityVisual", "map_entity"
		)

## Initiates this visual once added to a VisualContainer.
## Also, sets the current entity.
func setup(e: AlephVault__WindRose.Maps.MapEntity):
	_map_entity = e
	_setup()

# Implement this method with the actual setup logic.
# _map_entity will be set.
func _setup():
	pass

## Terminates this visual once added to a VisualContainer.
## Also, unsets the current entity.
func teardown(e: AlephVault__WindRose.Maps.MapEntity):
	_map_entity = null
	_teardown()

# Implement this method with the actual setup logic.
# _map_entity will be already unset.
func _teardown():
	pass

## pauses any animation logic.
func pause():
	if not _paused:
		_paused = true
		_pause()

# Implement this method with the actual pause logic.
func _pause():
	pass

## Resumes any animation logic.
func resume():
	if _paused:
		_paused = false
		_resume()

# Implement this method with the actual resume logic.
func _resume():
	pass

## Updates any animation logic.
func update(delta: float):
	if _map_entity != null:
		_update(delta)

# Implement this method with the actual update logic.
func _update(delta: float):
	pass
