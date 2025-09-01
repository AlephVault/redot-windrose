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

## Resets this visual once added to a VisualContainer.
func reset():
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
	pass
