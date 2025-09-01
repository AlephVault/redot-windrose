extends Sprite2D
## A map entity visual is an image that has a custom
## behaviour and is attached to an entity. Entities
## can have many of these objects as representations
## (e.g. character shapes, effects, overlays, ...).

func _process(delta):
	position = Vector2.ZERO

## pauses any animation logic.
func pause():
	pass

## Resumes any animation logic.
func resume():
	pass
