extends AlephVault__WindRose.Triggers.Teleports.Teleport
## This teleport knows the target by simple / fixed settings.
## In this case, this means that the teleport target will be
## simply / statically specified, and not dynamically (e.g.
## by loading a map dynamically). This can be setup in the
## scene to fixed objects in the map (must be MapEntity nodes
## in the scene) or to proper names / values in entities in
## the same or other maps.

## The teleport target node. If specified and being a valid
## AlephVault__WindRose.Maps.MapEntity object (which must
## also be attached to a valid Map at that point), it will be
## used as teleport target. Otherwise, there are properties
## to specify a target by its scope, map index, and entity
## name in that case.
@export
var target: Node2D

## The scope key where the target is located. Used when the
## target property is not set to a valid entity inside a map,
## this property tells the key of a scope the target belongs
## to. If the scope is empty, this means the scope is not
## used and the lookup is done in the same scope (perhaps
## another map). If the scope is set and invalid, the lookup
## will fail and the teleport will not work. If the scope is
## set and valid, the current map must belong to the scope
## which belongs to a World (AlephVault__WindRose.Maps.World)
## having a scope with the required key (or else the lookup
## will fail and the teleport will not work).
@export
var target_scope_key: String = ""

## The map index where the target is located. Used when the
## target property is not set to a valid entity inside a map,
## this property tells the index of a map the target belongs
## to. If the index is -1, this means the map is not used and
## the lookup will occur in the same map. If it is >= 0, the
## map must belong to a scope and the index must be a valid
## map index among the scope's maps. Otherwise, the lookup
## will fail and the teleport will not work.
@export
var target_map_index: int = -1

## The name of the node being the target entity. Used when the
## target property is not set to a valid entity inside a map,
## this property tells the name of a node being the target
## entity. If the name is not set, the lookup will not work.
## The name will be used for the lookup in the corresponding
## map (whichever is picked) and the node will be retrieved.
## The node with that name must exist inside the map and be a
## of type AlephVault__WindRose.Maps.MapEntity. 
@export
var target_name: String = ""

## Returns the teleport target. The target will be retrieved
## from either the target property, or the target_scope_key,
## target_map_index and target_name properties, accordingly.
func _get_teleport_target() -> AlephVault__WindRose.Maps.MapEntity:
	if is_instance_valid(target) and target is AlephVault__WindRose.Maps.MapEntity:
		return target
	var current_map = map_entity.current_map
	if current_map == null:
		return null
	var scope_key: String = target_scope_key.strip_edges()
	var map_index: int = target_map_index
	var node_name: String = target_name.strip_edges()
	var node: Node2D
	if scope_key == "":
		if map_index < 0:
			# Lookup on same map.
			node = current_map.entities_layer.get_node(node_name)
		else:
			# Look on the same scope, another map.
			if current_map.scope == null:
				return null
			node = current_map.get_scope_map(map_index).entities_layer.get_node(node_name)
	else:
		if map_index < 0:
			# Specifying the scope and not a valid
			# map index results in failed lookup.s
			return null
		else:
			# Look on a given scope and map.
			if current_map.scope == null or current_map.scope.world == null:
				return null
			node = current_map.get_world_map(scope_key, map_index).entities_layer.get_node(
				node_name
			)
	if is_instance_valid(node) and node is AlephVault__WindRose.Maps.MapEntity and node.current_map != null:
		return node
	return null
