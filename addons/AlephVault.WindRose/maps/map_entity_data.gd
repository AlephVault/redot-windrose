extends Object
## Stores byte data attached to a map entity. Each subclass has its own
## methods to store and manage that data.

var _data: PackedByteArray = PackedByteArray()

## Gets the current data snapshot.
var data: PackedByteArray:
	get:
		return _data.duplicate()
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapEntityData", "data"
		)

## This signal tells when the data is updated. The argument is the
## partial data being applied. The final data is already updated.
signal data_updated(data: PackedByteArray)

func _init(data: PackedByteArray = PackedByteArray()):
	_data = data.duplicate()

## Updates the stored data. When merge is true, the new data is appended.
func update_data(data: PackedByteArray, merge: bool = false) -> bool:
	if merge:
		_data = _merge_data(_data, data)
	else:
		_data = data.duplicate()
	data_updated.emit(data.duplicate())
	return true

## Override this function to define how the data is merged to the source
## data from an object.
func _merge_data(data: PackedByteArray):
	pass

## Override this function to define how the data is serialized into
## a packed bytes array.
static func _serialize(data: Variant) -> PackedByteArray:
	AlephVault__WindRose.Utils.AccessUtils.not_implemented("MapEntityData", "_serialize")
	return PackedByteArray()

## Override this function to define how the data is deserialized from
## a packed bytes array.
static func _deserialize(data: PackedByteArray) -> Variant:
	AlephVault__WindRose.Utils.AccessUtils.not_implemented("MapEntityData", "_deserialize")
	return null
