# WindRose

This package provides features to create games with discrete, bi-directional, RPG movement games with
cell-fixed movement games (suitable for deterministic MMORPG games).

## Main Elements

The important elements related to this package are:

1. Tilemaps: Tilemaps are a Redot feature involving discrete 2-dimensional representation and movement.
   They have a lot of features, but this package makes a very limited use of these. Related objects are:

   1. `TileMapLayer` objects: They're in-scene objects used to represent tilemaps (e.g. floors).
   2. `TileSet` objects: They're in-project resource objects used to provide the tiles that will be used
	  in `TileMapLayer` objects. A feature being used in the tilesets are the _data layers_, which are
	  retrieved by the underlying logic of the related objects.

2. Maps: Contrary to what it might look, maps are not Tilemaps per se. They make use of tilemaps
   (TileMapLayer) objects in a more complex (yet manageable) way and also add a way to manage the objects
   that can be included in the map.

3. Map Entities: These are the objects (or characters) that belong to a map. Map entities can be attached
   to a map, detached from a map, teleported inside a map, moved inside a map, or even aborting a movement
   inside a map.

## Installation

This package might be available in the Redot/Godot Asset Library. However, it can also be installed
right from this repository, provided the contents of the `addons/` directory are added into the
project's `addons/` directory, in particular `addons/AlephVault.WindRose`, which is the sub-package
being described in this documentation file.

## Usage

Using this package may be as simple as just using it, or as complex as extending it. This depends on whether
the current state of the package correctly satisfies the needs of the developer for the specific game being
developed (most of the typical use cases are already covered, but nobody here has the last word on this topic).

### Creating maps and characters

This is the simplest use case, and the first the users must understand in order to interact with this package.

The first thing is to understand how maps work and what kind of _rules_ exist for those maps. The available
rules (any developer can create their own rule later) are available in the following namespaces:

1. `AlephVault__WindRose.Contrib.Dummy`: Rule telling that objects in the map are free to move, as long as
   they're trying to move inside the boundaries of the map. Objects will not collide with anything but the
   borders of the map.
2. `AlephVault__WindRose.Contrib.Blocking`: Rule telling that objects in the map are restricted to move when
   colliding with one or more cells tagged as _blocking_. Objects will not be restricted by other objects to
   move, but only by the map's boundaries and _blocking_ cells.
3. `AlephVault__WindRose.Contrib.Solidness`: Rule telling that objects in the map are restricted to move when
   colliding with one or more objects (there are exceptions and configurations for this, however, but typically
   this means that e.g. a character can block the road to another character, and so). Also, the map's boundaries
   will still restrict the movement of any object.
4. `AlephVault__WindRose.Contrib.Neighbours`: Rule telling that objects in the map can be teleported to some
   map regarded as _neighbour_ in a specific direction, for objects to be teleported to the neighbour map (at
   the same matching border position) when walking to the map's boundary in the matching direction. This allows
   defining a scene where many maps exist and characters can move from a map to a neighbour map by reaching the
   proper map's boundary. The only movement restricted by this rule is related to reaching the map's boundaries,
   but also in this particular case it might involve teleportation rather than blocking.
5. `AlephVault__WindRose.Contrib.Navigability`: Rule telling that objects in the map are restricted to move
   when colliding with one or more cells with a _navigability mask_ not including the current object's one.
   For example, games where characters need a ship or boat to go through water cells are a good example, since
   they need to use a ship / boat to walk through water, while at the same time they need to _not_ use it when
   they need to walk on grass or ground. This rule also restricts movement by map's boundaries, as the others.
   Cells determine their mask by traversing the _navigability_-related properties of their tiles.
6. `AlephVault__WindRose.Contrib.Simple`: This rule is a combination of the previous four rules, thus being
   restrictive by a combination of the previous rules: _blocking_, _navigability_ and _solidness_. This, while
   also supporting crossing boundaries to a neighbour map in the corresponding direction. It also restricts
   the movement by the usual boundaries criterion from the other rules. **This is the rule that users will
   typically choose in their projects**.

If, for some reason, these rules are not enough, there's a section in this document about advanced development,
so users learn how to create new rules for their particular needs. But, in the majority of cases, the `Simple`
rule is more than enough.

Once a rule is picked (let's take, for example, `Simple`), the next thing to understand is the structure of
the chosen rule namespace. All those 6 rule namespaces have the following identifiers:

- `EntityRule`: This is the implementation of the rule that must be related to the map entities. Typically, only
  advanced development cares about this class.
- `EntitiesRule`: This is the implementation of the rule that must be related to maps (actually: a special Map
  component we'll call _entities layer_). Typically, only advanced development cares about this class.
- `EntitiesLayer`: This is the implementation of what we call here a _map layer_. It is a component that goes
  inside a map. When choosing one of the rules described earlier, **this component is important and must be used
  in each of the maps, as a single child node of each map**.
- `MapEntity`: This is the implementation of a _map entity_. Map entities can be created at runtime or at design
  time, as part of a scene.

  1. As part of a scene, a map entity must start being a child of an entities layer. On `_ready`, the map entity
	 will _initialize_ and recognize itself as part of the map. It will become _attached_ to the map.
  
  
