extends Object

## This is a dummy utility to complain about properties
## that are meant to not be settable.
static func cannot_set(klass: String, property: String):
	assert(false, "%s.%s cannot be set this way" % [klass, property])

## This is a dummy utility to complain about methods
## that are not implemented yet.
static func not_implemented(klass: String, property: String):
	assert(false, "%s.%s is not implemented" % [klass, property])
