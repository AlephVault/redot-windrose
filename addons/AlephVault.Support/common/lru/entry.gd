extends Object
## A cache entry accounts for a specific value and
## all the references that track this entry. Also,
## whether this element is queued for disposal or
## not (instead: being an active entry).

var _value
var _references: Dictionary = {}
var _queued: bool = false

## Returns the current value for this entry.
var value:
    get:
        return value

func _init(value):
    _value = value

## Prunes all the references that belong to objects
## that are not valid references anymore (i.e. were
## deleted long time ago). This updates the dict of
## references, removing stale ones.
func prune_references():
    var stale_ids: Array[int] = []
    for object_id in references.keys():
        var object_ref: WeakRef = references[object_id]
        if object_ref == null or object_ref.get_ref() == null:
            stale_ids.push_back(object_id)
    for object_id in stale_ids:
        references.erase(object_id)

## Returns the count of references (prunes them first)
## to this entry.
func reference_count() -> int:
    prune_references()
    return references.size()

## Adds a reference to this entry.
func add_reference(obj: Object):
    references[obj.get_instance_id()] = weakref(obj)

## Removes a reference from this entry.
func remove_reference(obj: Object):
    references.erase(obj.get_instance_id())
