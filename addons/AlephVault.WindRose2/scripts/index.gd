extends Object

class_name AlephVault__WindRose2

class Layout:
	const World = preload("./layout/World.gd")
	const Scope = preload("./layout/Scope.gd")

class Maps:
	const Map = preload("./maps/Map.gd")
	const Layer = preload("./maps/Layer.gd")
	class Rules:
		const Rule = preload("./maps/rules/Rule.gd")

class Entities:
	const Layer = preload("./entities/Layer.gd")
	const Entity = preload("./entities/Entity.gd")
	class Rules:
		const Rule = preload("./entities/rules/Rule.gd")

class Drops:
	const Layer = preload("./drop/Layer.gd")

class Ceilings:
	const Layer = preload("./ceiling/Layer.gd")

class Utils:
	pass
