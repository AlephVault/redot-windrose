extends AlephVault__WindRose.Triggers.Trigger
## Teleporters are a way to teleport objects across
## the same map or different maps.

## Returns the teleport target. If it is null, then
## no teleport will be performed.
func _get_teleport_target() -> AlephVault__WindRose.Maps.MapEntity:
	return null

# Tells whether an object's position/size is fully
# contained by the current (trigger) entity. This
# means that the rectangle of the entity must have
# its boundaries inside this entity's rectangle.
func _is_fully_contained(e: AlephVault__WindRose.Maps.MapEntity) -> bool:
	return e.cell.x >= map_entity.cell.x and \
		   e.cell.y >= map_entity.cell.y and \
		   e.cellf.x <= map_entity.cell.x and \
		   e.cellf.y <= map_entity.cell.y

# Tells whether an entity is moved inside the teleport
# and, if matching completely, will be teleported to
# a relevant position in the target.
func _entity_moved(e: AlephVault__WindRose.Maps.MapEntity):
	if not _is_fully_contained(e):
		return
	
	var delta: Vector2i = e.cell - map_entity.cell
	_do_teleport(e, delta)

## Implement this custom callback to do something before
## the teleport takes place. Typically, this method is
## async and makes an animation or transition.
func _before_teleport(e: AlephVault__WindRose.Maps.MapEntity):
	pass

## Implement this custom callback to do something after
## the teleport takes place. Typically, this method is
## async and makes an animation or transition.
func _after_teleport(e: AlephVault__WindRose.Maps.MapEntity):
	pass

# Performs a teleport of the entity to a new map.
func _do_teleport(
	e: AlephVault__WindRose.Maps.MapEntity,
	delta: Vector2i
):
	var target: AlephVault__WindRose.Maps.MapEntity = await _get_teleport_target()
	if target == null or target.current_map == null:
		return
	elif e.current_map == target.current_map:
		e.teleport(target.cell + delta)
	else:
		await _before_teleport(e)
		e.detach()
		e.attach(target.current_map, target.cell + delta)
		await _after_teleport(e)
