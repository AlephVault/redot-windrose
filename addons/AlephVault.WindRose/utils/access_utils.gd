extends Object

## This is a dummy utility to complain about properties
## that are meant to not be settable.
static func cannot_set(klass: String, property: String):
	assert(false, "%s.%s cannot be set this way" % [klass, property])
