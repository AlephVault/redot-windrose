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
	 
	 > If, for some reason, it is _not_ child of an entities layer, then the initialization logic will **not**
	   occur and must be triggered manually.
	 
	 > Also, being a child of an entities layer, if the object does not look fully contained in the map, it will
	   raise an error when trying to initialize and auto-attach to the map. Ensure that, in the editor, the
	   entity is _fully into the map_, which means: its in-tilemap position + its size (defined in the editor
	   for that object) is lower than or equal to the map size.
  
  2. Otherwise, by creating the entity at runtime (e.g. `obj = AlephVault__WindRose.Contrib.Simple.MapEntity.new(...)`),
	 the entity must have its `initialize()` method manually invoked (`obj.initialize()`) and, either immediately
	 or previously, be already added (_parented_) to the entities layer for it to interact in a map.

In order to create a map in a scene (to be loaded directly or indirectly as an asset), the typical workflow is:

  1. Create the Map node as a `Node2D`. Name it as you prefer.
  2. As a child of the Map node, create the Floor Layer node as a `Node2D`. Name it as you prefer.
  3. As another child of the Map node, create the Entities Layer node as a `Node2D`. Name it as you prefer.
  4. As child / children of the Floor Layer node, create as many `TileMapLayer` nodes you need.
	 This also requires properly creating `TileSet` resources, and the proper tiles there-in.
	 **All the involved TileSet resources must be configured to use one of the allowed tile settings or
	 the entire map will not work properly**. The allowed settings are: Squared, Isometric (Diamond Right), and
	 Isometric (Diamond Down). **This is serious: others will not work**.
  5. If planning to use Simple, Blocking, Navigability or another custom rule relying on tiles' data,
	 configure the TileSets' data layers and individual cells' data accordingly. This will be described later.
  6. In the Map node, drag/attach the `addons/AlephVault.WindRose/maps/map.gd` script.
  7. In the Floor Layer node, drag/attach the `addons/AlephVault.WindRose/maps/layers/floor_layer.gd` script.
  8. In the Entities Layer node, drag/attach the **corresponding entities_layer.gd script**. For already provided
	 scripts, choose the proper path. For example, if planning to use the Simple rule, then the script to attach
	 is at `addons/AlephVault.WindRose/contrib/simple/entities_layer.gd`, while other out-of-the-box rules have
	 similar file paths. Then, configure all the needed properties (e.g. navigability and simple rules allow the
	 configuration of the neighbour maps for the four boundaries of the current map).
  9. Configure the desired map's size. This is important.

The next thing is to create an entity. In this case, the steps are:

  1. Create the MapEntity node as a `Node2D`. Name it as you prefer.
  2. Give anything you deem useful. As an example, consider adding a child `Sprite2D` to serve as a static image.
  3. Drag/attach the **corresponding map_entity.gd script**. For already provided scripts, choose the proper path.
	 For example, if planning to use the Simple rule (matching the example with the entities layer defined earlier),
	 the path is: `addons/AlephVault.WindRose/contrib/simple/map_entity.gd`.
  4. Configure a speed (the minimum speed will be 0.001), expressed in pixels / second, and a size (e.g. 1x1, which
	 is a typical setup for a character). You are free to configure an orientation. Also, configure all the other
	 properties that are useful (e.g. for navigability or simple map entity, the navigability attribute can be
	 configured to choose another non-default navigability).

Once there, the maps and entities are ready to be used:

  1. On `_enter_tree`, maps are typically initialized. If, for some reason, they're not, then you can manually call
	 `initialize()` on the map. Ensure it's already added into the scene when doing this.
  2. As part of the map's initialization, its entities layer is initialized as well. If, for some reason, this did
	 not happen, then you can manually call `initialize()` on the entities layer child.
  3. As part of the entities layer initialization, its children being map entities will have their `initialize()`
	 invoked as well. If for some reason this does not happen, or the objects are created later and / or not as
	 children of any entities layer, then you can call `initialize()` manually on them. It should also happen that,
	 if you create the object and add it as child of an entities layer in the same frame, then the object will
	 indeed automatically initialize and be attached to the parent entities layer and thus the grandparent map.

### Optional: World and scopes

A single scene may have typically one world and many scopes inside the world. Scopes, in turn, can contain one or
more maps each. Ideally, each scope serves as some sort of "level" and, while typically has one map, it can have
more than one map, but they'd be visible / related at the same time. For online games, a concept of scope may have
its own set of connections (i.e. all the connections in a single scope will notify each other through some sort of
central server).

This system of scopes and worlds is entirely optional, for maps can be used without them. The main and only element
of this scope is a registry where the scope key will track to its scope, and in-scope map index will track to the
map instance itself. The life-cycle can be understood like this:

1. Instantiate (statically or dynamically) a World node (`AlephVault__WindRose.Maps.World`, child of `Node2D`).

2. Instantiate (statically or dynamically) one or more Scope nodes.

3. _Appoint_ each previously created scope (`AlephVault__WindRose.Maps.Scope`, child of `Node2D`) instance into the
   world, by invoking `scope.appoint(world, "some-key")`. A scope cannot be registered twice in the same world, and
   the same key (e.g. `"some-key"`) cannot be used twice in the same world as well. A `Response` is returned, which
   has a `.is_successful()` method to test whether the appointment was successful or an error occurred. A scope cannot
   be appointed to two different worlds.

4. Retrieve the current key of the scope (as it was registered in the previous step) with `var _key: String = scope.key`.

5. Retrieve a registered scope from the world: `var scope: AlephVault__WindRose.Maps.Scope = world.get_scope(key)`.
   If the key is invalid, returns `null`.

6. _Drop_ a previously appointed scope, by invoking `scope.drop()`. It returns a `Response` instance, which returns
   `.is_successful()` method to test whether the drop was successful or not.

7. Inside a scope, register a map (`AlephVault__WindRose.Maps.Map`, child of `Node2D`) automatically by adding it as
   a child node. A map has its `index` (read-only, and must be unique across maps in the same scope) property that will
   be used to auto-register the map in the scope.
   
   > Typically, scopes and maps are defined in a factory scene (to be dynamically instantiated, perhaps many times).
	 This is why the index is pre-defined as a static property inside the map.

8. In a scope, you can retrieve a map by invoking `var _map: AlephVault__WindRose.Maps.Map = scope.get_map(index)`,
   where the index is an integer that matches the index of an automatically registered map. It will return `null`
   if the index is not valid.

9. In a world, retrieve a map by invoking `var _map: AlephVault__WindRose.Maps.Map = world.get_map(key, index)`.
   The scope key and map index must be used together for this purpose, and any invalid value will cause the result
   to be `null` like in the previous cases.

### General properties

Let a valid map instance be: `var map: AlephVault__WindRose.Maps.Map`:

- `scope: AlephVault__WindRose.Maps.Scope`: Returns the current scope, if scopes are used, this map is added to.
  If it's not used / not under a valid scope, this value will be `null`.
- `index: int`: Returns the current map index. Only meaningful if the map belongs to a scope. This property is
  read-only at runtime (set at editor time).
- `size: Vector2i`: Returns the size of the map. Each coordinate is integer and positive, and lower than or equal
  to 4096 (this means: a map can be at most 4096x4096). This property is read-only at runtime (set at editor time).
  Entities in this map will have their positions constrained by these dimensions. The dimensions are constrained
  to be between `(1, 1)` and `(4096, 4096)`.
- `gizmo_x_axis_color`, `gizmo_y_axis_color` and `gizmo_grid_color`: These properties only serve for debugging
  purposes in the editor, since they provide a grid ad hoc to track the objects even before the tilemaps have their
  cells properly filled. All these properties are of type `Color`.
- `floor_layer: AlephVault__WindRose.Maps.Layers.FloorLayer`: Returns the floor layer for the map. This layer is
  read-only and set on initialization, by detecting a direct child being of this type.
- `visuals_layer: AlephVault__WindRose.Maps.Layers.VisualsLayer`: Returns the visuals layer for the map. This layer
  is read-only and set on initialization, by detecting a direct child being of this type. Visuals layers have their
  own section: `Understanding Entity Visuals`. This layer is optional.
- `entities_layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer`: Returns the entities layer for the map. This
  layer is read-only and set on initialization, by detecting a direct child of this type. The actual type of layer
  is a sub-type of entities layer, with its own logic, depending on the intended rule to apply to the map.
- `layout: AlephVault__WindRose.Maps.Utils.MapLayout`: Returns the layout for the map. This layout is read-only and
  detected from the map-related objects. Layouts are related to one of the three combinations of tilemap (actually:
  tileset) properties that are allowed: squared, diamond-down isometric or diamond-right isometric.
- `get_world_map(key: String, index: int) -> AlephVault__WindRose.Maps.Map`: Returns another map in the same world
  this map belongs to. If it does not belong to any scope or the key / index are not valid, returns `null`.
- `get_scope_map(index: int) -> AlephVault__WindRose.Maps.Map`: Returns another map in the same world this map
  belongs to. If it does not belong to any scope or the index is not valid, returns `null`.
- `func pause()`: Pauses this map and its EntitiesLayer.
- `func resume()`: Resumes this map and its EntitiesLayer.
- `var paused: bool`: Tells whether this map is paused or not (see the previous two methods).

About maps, most of the logic is not tied to them directly, but to the underlying layers instead. These layers (as
of today: entities layer and floor layer) must be created with the map, and will be detected on map's `_ready` and
when the hierarchy changes (under normal conditions, it should not change).

Let a valid floor layer instance be: `var floor_layer: AlephVault__WindRose.Maps.Layers.FloorLayer`:

- `map: AlephVault__WindRose.Maps.Map`: Returns the parent map.
- `get_tilemap(index: int) -> TileMapLayer`: Returns a child `TileMapLayer` by index.
- `get_tilemaps_count() -> int`: Returns the number of children `TileMapLayer` objects.

About floor layers, the only logic they perform is to auto-detect, on `_ready` and when the hierarchy changes (under
normal conditions, it should not change), the list of tilemaps.

Let a valid entities layer instance be: `var entities_layer: AlephVault__WindRose.Maps.Layers.EntitiesLayer` (but,
actually, **a descendant of that type**, and not that type directly):

- `rule: AlephVault__WindRose.Core.EntitiesRule`: Returns the rule related to this layer. When this property is
  first-read, the creation of the underlying entities rule instance will take place (this only happens once). The
  particular rule sub-type is determined by the custom logic of the current entities layer.
- `manager: AlephVault__WindRose.Core.EntitiesRule.Manager`: Returns the underlying manager. Managers are special
  internal objects that handle the whole movement (and thus: underlying rule execution) of an entities layer and
  their entities. They effectively manage the lifecycle of each single frame and see in first row the movement of
  the entities in the current layer.
- `bypass: bool`: This flag allows the rule to always allow any movement from any entity in the layer. This only
  makes sense if the game is a client connected to a server which, in place, does not have this flag active. In
  the client case, however, everything is allowed since the true logic comes from the server. This property is
  read-only and only set in the editor.
- `initialized: bool`: Also a read-only property, this flag tells whether this layer is already initialized.
- `initialize()`: This method is invoked by the parent map, but can be manually invoked if needed. This method
  creates the internal `manager` and then detect all the children objects which are map entities and then, one
  by one, it initializes each of those entities, properly attaching them to this entities layer.
- `func pause()`: Pauses this entities layer and all of their MapEntity contained objects. They get to be still
  / frozen, but visible when they should be visible.
- `func resume()`: Resumes this entities layer and all of their MapEntity contained objects. They get to be
  animated again.
- `var paused: bool`: Tells whether this entities layer is paused or not (see the previous two methods).


About entities layers, they have more properties and a custom rule instantiation according the sub-type of layer
being used. They will be timely described in other sections.

Let a valid map entity instance be: `var map_entity: AlephVault__WindRose.Maps.MapEntity`:

- `rule: AlephVault__WindRose.Core.EntityRule`: Returns the rule related to this entity. When this property
  is first-read, the creation of the underlying entity rule instance will take place (this only happens once).
  The particular rule sub-type is determiend by the custom logic of the current map entity. This property is
  read-only.
- `entity: AlephVault__WindRose.Core.EntityRule`: Returns the logical entity to be used. This is an underlying
  model that triggers the internal logic related to the map (layer) it belongs. It does not trigger the actual
  movement, but helps in all the related checks and triggers. This property is read-only.
- `current_map: AlephVault__WindRose.Maps.Map`: Returns the current map this map entity is attached to. This
  property is read-only.
- `size: Vector2i`: Returns the dimensions of this entity. Each dimensions is greater than 0. This property
  is read-only at runtime, and configurable via editor.
- `cell: Vector2i`: Returns the current cell this object is attached to. If it is not attached to any map,
  returns (-1, -1). If the object is not 1x1 in dimensions, this cell in particular references the top-left
  corner of the entity.
- `cellf: Vector2i`: If the object is 1x1, this is the same `cell` value. If the object is not 1x1, this
  is the coordinate of the opposite corner (bottom-right) of the entity in the map.
- `initial_position: Vector2i`: If this position is set both components to non-negative values, and the
  entity is being initialized in a map (this only makes sense when setting this up statically in the editor,
  not when creating the entity dynamically), then this position is used for the entity to be attached.
  At runtime, this property is read-only. If you don't set the initial position, then a best guess will be
  done for the in-space position to calculate the in-map position.
- `orientation: AlephVault__WindRose.Utils.DirectionUtils.Direction`: Sets or returns the orientation of
  this entity. The signal `orientation_changed` is triggered with the new direction on assignment.
- `signal orientation_changed(AlephVault__WindRose.Utils.DirectionUtils.Direction)`: A signal triggered when
  the orientation changes in this entity. Features like animation, game logic, or potentially custom rules
  can pay attention to this feature.
- `speed: float`: Sets or returns the speed of this entity. The speed is expressed in pixels. The signal
  `speed_changed` is triggered with the new speed on assignment. It is always clamped to be greater than or
  equal to `0.001`.
- `signal speed_changed(float)`: A signal triggered when the speed changes in this entity.
- `state: int`: Sets or returns the state of this entity. Like with the orientation, the state is an optional
  feature, highly used when in the need of animating the aesthetics of an entity. This is just a number, and
  the default value is `AlephVault__WindRose.Maps.MapEntity.STATE_IDLE` (0). It is up to the developer to
  give meaning to any state number. When this state is changed, it triggers `state_changed(state)`.
- `signal state_changed(int)`: A signal triggered when the state changes in this entity.
- `signal updated()`: A signal emitted on every frame for this entity. With this in mind, elements like visual
  aesthetics manager can connect arbitrary parameterless callbacks so they know when an entity is being updated
  (`_process`) and can act accordingly.
- `func initialize()`: A function that is typically invoked automatically but can be manually invoked by the developer.
  This function prepares the internal (logical) entity, size and signals for this map entity.
- `func attach(map: AlephVault__WindRose.Maps.Map, to_position: Vector2i) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`:
  A method to attach this map entity to a map. This entity must not be previously attached to the map. Also,
  this entity's rule must be compatible to the entities rule in the entities layer of the target map (this
  means: the developer must make sure the map's entities layer and the map entity come from the same parent
  namespace or family). Once the object is attached, it begins to interact with the map and other objects
  according to the underlying entity / entities rules pair. The result is a `Response` object, which has a
  `.is_successful()` method to get whether it could be attached or not. The `current_map` property will be
  updated after the invocation of this method, and must be `null` before the invocation of this method.
  Proper signals will be triggered when the object is attached. If the object was already attached to a map,
  the response will be successful, but with a `false` value rather than `true`.
- `func detach() -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: This method causes the map entity to
  be detached from whichever was the current map, if any. The `current_map` property must be non-`null` when
  invoking this method (otherwise, the result will be a successful-yet-`false` one). It will become `null` after
  invoking it.
- `func teleport(to_position: Vector2i) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: This method causes
  the map entity to go to a different position in the map, as long as it's valid. If the object is not attached to
  a map, the result is successful but with a `false` value. Errors may be triggered (e.g. if the new position is
  out of bounds in the current map). Proper signals will be triggered on success, telling that the object was
  moved from a position to the new one automatically. Any current movement will be indirectly canceled prior to
  the teleport to take place.
- `func start_movement(direction: AlephVault__WindRose.Utils.DirectionUtils.Direction) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`:
  This method causes the map entity to start a movement. It will succeed with a `false` value if the map entity is
  not attached to a map or could not start moving because of reasons related to the underlying rules. If the entity
  was already performing a movement, the new movement intent is stored as _queued_ for a very short time, automatically
  starting if in that lapse the entity finished its current movement (in less than that very short time). This allows
  a seamless movement and a smooth movement experience.
- `func cancel_movement() -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: This method causes the current
  movement, if any, to be canceled. The result will be successful with a value of `true` if the entity is attached
  to a map and the rules allowed the movement to be canceled. Otherwise, it will be a successful result with a
  `false` value.
- `func add_visual(v: AlephVault__WindRose.Maps.MapEntityVisual)`: Adds a visual to this entity. There is a section
  for this feature: `Understanding Entity Visuals`.
- `func remove_visual(v: AlephVault__WindRose.Maps.MapEntityVisual)`: Removes a visual from this entity. There is a
  section for this feature: `Understanding Entity Visuals`.
- `func pause()`: Pauses this entity's visual (`AlephVault__WindRose.Maps.MapEntityVisual`) objects. They get to be
  still / frozen, but visible when they should be visible.
- `func resume()`: Resumes this entity's visual (`AlephVault__WindRose.Maps.MapEntityVisual`) objects. They get to be
  animated again.
- `var paused: bool`: Tells whether this entity is paused or not (see the previous two methods).

Finally, interacting with the signals for movements and teleport is done through the `rule` property:

- `signal rule.signals.on_attached(manager, position: Vector2i)`: Triggered when the entity was attached to a
  specific manager (get the Map reference through `manager.layer.map`) and at a given position (the entity's
  top-left corner, if not 1x1, will be the one occupying that position).
- `signal rule.signals.on_detached()`: Triggered when the entity was detached from its current map.
- `signal rule.signals.on_movement_started(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`:
  Triggered when the entity started moving in certain direction, from a specific source position to a specific
  target position (both just 1 step away).
- `signal rule.signals.on_movement_finished(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`:
  Triggered when the entity finished moving in a certain direction, from a specific source position to a specific
  target position (both just 1 step away).
- `signal rule.signals.on_movement_cancelled(from_position: Vector2i, reverted_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`:
  Triggered when the entity canceled moving in a certain direction, from a specific source position to a specific
  target (reverted) position (both just 1 step away). If the entity was not currently moving, the direction will be
  `AlephVault__WindRose.Utils.DirectionUtils.Direction.NONE`.
- `signal rule.signals.on_teleported(from_position: Vector2i, to_position: Vector2i)`: Triggered when the entity
  was teleported to a new cell in the same map.
- `signal rule.on_property_updated(prop: String, old_value, new_value)`: Triggered when a property notified being
  changed in the rule. If the current rule is composed from many children rules, each child rule will have a way
  of calling an emit of this signal in the parent rule. This is something that children rules must each do in their
  own `on_property_updated` signal (forwarding an emit to the parent). However, from the perspective of the end
  user / developer, just attending this signal as-is will have the job done for their purposes (however, creating
  new rules will be covered in the advanced development section; take a look at the implementation of the `Simple`
  entity rule, at `addons/AlephVault.WindRose/contrib/simple/entity_rule.gd`, to have an example of forwarding
  from child to parent in the entity rule, and then take a loot at its `entities_rule.gd` to have an example of
  forwarding from parent to child).

With this description, development of rule-aware entities, and entities-aware game logic, can be implemented
with no major problems. The next sections will cover specific topics like:

1. Features of the dummy (null) rule.
2. Features of the blocking rule.
3. Features of the solidness rule.
4. Features of the neighbours rule.
5. Features of the navigability rule.
6. Features of the simple rule.
7. Advanced development: creating custom rules.

### Dummy rule-related properties and methods

There are no particular properties on either component of this dummy rule. This dummy rule allows any properly
bounded behaviour.

### Blocking rule-related properties and methods

There are no particular properties on either component of this blocking rule. However, in order to restrict the
movement, tiles must tell whether they block or allow the movement for a given cell they're painted into. The blocking
algorithm goes like this:

1. Initially, each cell allows movement.
2. From the topmost (`N-1`th `TileMapLayer` child of the _floor layer_) to the bottommost (0th `TileMapLayer` child of
   the _floor layer_) tilemap, get the tile used at the cell to check and whether the tilemap uses a tileset that has
   a custom data layer defiend with name `"blocking"` and boolean type. If there's no tile at that cell or the tileset
   does not have such custom layer defined, skip this check for this tilemap. Otherwise, return whether the tile has
   its `"blocking"` value (from the custom data layer) to `true` or `false`. This value is returned as the result and
   used to determine whether the movement is blocked for that cell, or not.
3. If no tilemap, for that cell, can determine (given the above criterion) whether the movement is blocked or not, then
   the result is `false` (the movement is not blocked).

When an entity tries to move in any direction where it finds (given, accordingly, its width or height) a cell marked
as blocking, then movement in that direction is not allowed. There are no more checks and this check is static as long
as the tilemaps are not changed.

If a developer wants to change the contents of a tile for any tilemap in the map for a given (x, y) cell dynamically,
then they must invoke `map.entities_layer.rule.update_cell_data(Vector2i(x, y))`. This will update the blocking data
layer for that cell in particular.

### Solidness rule-related properties and methods

The solidness rule is the only one, provided here, which has many properties to account for. Those properties exist
only in the _entity rule_ (the rule that is part of the map entity). The properties, in this rule, are:

- `obeys_solidness: bool`: If this property is `false`, then the movement of this entity is not restricted by solidness,
  but only by the boundaries of the map. If it is `true` (default), then this rule applies for this entity. It is like
  a convenient entity-side _bypass_, but useful in very few cases for games requiring solidness. On `false`, while the
  entity does not have its movement restricted by this rule, it still modifies the current data to perhaps restrict the
  movement of other objects.
- `solidness: AlephVault__WindRose.Contrib.Solidness.EntityRule.Solidness`: Tells the solidness of this rule. This
  value is an enumeration (the type supports members: `SOLID`, `GHOST`, `HOLE` or `IRREGULAR`). For the first 3 values,
  the criterion applies _to the entire rectangular shape and size of the entity_. For the `IRREGULAR` value, this entity
  is not enabled to move at all, but it modifies the current data _in a per-cell basis_ instead of a single criterion for
  the entire rectangular shape and size of the entity. The solid, ghost or hole criteria will be explained later in this
  section (irregular is already explained).
- `mask: String`: Tells, at editor time, the mask to use for `IRREGULAR` solidness entities. It is ignored in other types.
  The mask is a multiline string with character `'S'`, `'G'` or `'H'` (either lowercase or uppercase). Other characters
  will be treated as `'G'`. Each line will be trimmed to be equal to the width of the entity and right-padded with `'G'`
  if it is of less length. The total amount of lines will be trimmed to the height of the entity or padded with lines of
  `'G...G'` characters for the width of the object, each line. Each character tells the per-cell rule described in the
  `IRREGULAR` criterion in the `solidness` property. Examples:
  
  ```
  For a 3x3 character:

  SSS       SSS             SSS             SSS
  S   means SGG    while    SG   also means SGG due to truncation and padding.
  SSS       SSS             SSSS            SSS
							S
  
  For a 1x1 character:
  
  SGG
  HH  means S due to truncation
  S
  ```

- `optimistic: bool`: Tells that the movement is optimistic. This means that, when a movement is started, the final solidness
  data in the map is automatically updated (which means: the solidness is added to the newly occupying cells, and it is
  subtracted from the cells being left) so some use cases are allowed, like allowing a "train" of objects, which is not possible
  when optimistic is `false`: in this case, the solidness of the cells being left is not subtracted until the entity reaches
  the new position. However, the counterpart of this is that the entities marked with `optimistic` being `true` should not be
  canceled when they move, or the experience may become glitchy.

Now, this properties can all be set in the editor for the map entity (`MapEntity`) object. However, at runtime, these properties
can all be modified by accessing `map_entity.rule.{property}`, like `map_entity.rule.solidness`.

### Neighbours rule-related properties and methods

The neighbours rule doesn't restrict the movement but, optionally, can define maps that are connected to the boundaries. The
relevant properties only exist in the _entities rule_ (`EntitiesRule`), and nothing in the map entity. In this case, setting
the boundaries means that, for each direction, the developer is allowed to set the _next_ map whThere the entity must appear.
For example: if the left boundary is set for a map (an _entities rule_, actually) and a map entity (with its _entity rule_)
moves to a position `(0, y)` for any valid coordinate `y`, the map entity will be taken off the map and attached to the new
map at coordinates `(W-1, y)` where `y` is the same coordinate (due to constraints, `y` will be a valid value in the new map),
and `W` is the width of the new map.

At editor time, the properties are set in the _entities layer_ and the target values must also be of type `EntitiesLayer` of
the Neighbours namespace `AlephVault__WindRose.Contrib.Neighbours.EntitiesLayer`), although due to a limitation of the editor
any `Node2D` object will be allowed. **Please note** that objects not being _entities layer_ of the said type will be ignored
as if the respective property were not set.

At runtime, however, the properties are accessed through `entities_layer.rule.{property}` and they will not be of the _entities
layer_ type but, instead, of `AlephVault__WindRose.Contrib.Neighbours.EntitiesRule` type (they can be read or written).

The relevant properties are:

- `up_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule`: The rule of the map that will receive the map entity when
  it moves to `(x, 0)` in the current map. The rule (and corresponding map), if not `null`, must have the same width of the
  current rule (and map). The entity will appear at position `(x, H-1)` in the new map, where `H` is the height of the new map.
- `down_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule`: The rule of the map that will receive the map entity when
  it moves to `(x, H-1)` in the current map. The rule (and corresponding map), if not `null`, must have the same width of the
  current rule (and map). In this case, `H` is the height of the current map. The entity will appear at position `(x, 0)` in the
  new map.
- `left_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule`: The rule of the map that will receive the map entity when
  it moves to `(0, y)` in the current map. The rule (and corresponding map), if not `null`, must have the same width of the
  current rule (and map). The entity will appear at position `(W-1, y)` in the new map, where `W` is the width of the new map.
- `right_linked: AlephVault__WindRose.Contrib.Neighbours.EntitiesRule`: The rule of the map that will receive the map entity when
  it moves to `(W-1, y)` in the current map. The rule (and corresponding map), if not `null`, must have the same width of the
  current rule (and map). In this case, `W` is the width of the current map. The entity will appear at position `(0, y)` in the
  new map.

With this completely set up (it is optional, i.e. not all the directions need to have a mandatory map linked to it; even, the
same map can always be used to have a wrapping / _torus-like_ effect for a map) there's no need of extra set-up.

### Navigability rule-related properties and methods

The navigability rule is quite similar to the blocking rule, except that the map entity has a single property:

- `navigability: int`: This value starts at 0 and can be between 0 and 63, both inclusive. With this in mind, when the next cell(s)
  the map entity is trying to move to, by trying to move in certain direction, a navigability mask (64 bits) will be extracted from
  each corresponding cell and, if the navigability of the entity is not a bit turned on in the navigability mask of the cell, then
  the movement is not allowed for the entity. This is useful to have, e.g., walkable cells and water cells, where a ship or boat
  should be needed, thus changing the navigability of the entity (e.g. it cannot walk in water and cannot row a boat in the ground).

The _entities layer_ does not add new properties (which also means: the _entities rule_ does not add new properties). However, the
trick is on each cell. Similar to the `blocking` rule, the `TileMapLayer` objects are traversed from bottommost to topmost, and a
computation takes place to get the navigability mask for a cell (this computation is pre-cached - this will be discussed later in
this section):

1. Start with `mask: int = 1` for the `cell`.
2. For each `tilemap` from bottommost to topmost:
   - If, in the `tileset` there's no custom data layer named `navigability_type` or there's no custom data layer named `navigability_increments`,
	 then keep the current `mask`, unaltered. Those layers must be `int` and `bool`, respectively, or `mask` is, again, kept unaltered.
   - Retrieve the values from those layers for the given `cell`. The type must be an integer between 0 or 63, both inclusive. Otherwise,
	 the `mask` will be kept unaltered.
   - Now, we're on good values: If the value from `navigability_increments` is false, then `mask` gets assigned a 1-hot value for that bit.
	 For example, if `navigability_increments` is `false` and `navigability_type` is `5`, the `mask` becomes `32` (0000...0100000). However,
	 if `navigability_increments` is `true` and `navigability_type` is `5`, `mask` becomes `(mask | (1 << 5))`, activating the 5th bit. This
	 enables transitional navigability cells (e.g. shores).

If a developer wants to change the contents of a tile for any tilemap in the map for a given (x, y) cell dynamically, then they must invoke `map.entities_layer.rule.update_cell_data(Vector2i(x, y))`. This will update the navigability data layer for that cell in particular.

### Simple rule-related properties and methods

Again, this rule is a combination from all the previous rules (except for `dummy`, since it adds no logic at all).

- All the properties described in the _map entity_ on each of the previous rules are added to this _map entity_.
- All the properties described in the _entities layer_ on each of the previous rules are added to this _entities layer_. With the exception
  that the neighbours-related properties (e.g. `up_linked` and so), at editor time, must be _entities layer_ of this (`simple`) type instead.
- For both entity and entities rule, four members exist so they forward the logic properly: `navigability_rule`, `neighbours_rule`,
  `solidness_rule` and `blocking_rule` (in both cases, and of the respective types).
- **IMPORTANT**: All the notifications are forwarded, and all the criteria for allowing a movement in certain direction must be satisfied to
  allow a movement, simultaneously.

### Advanced development

This section is only needed for developers who need to create their own rules, or extend existing rules with new behaviour. In either case, the
thing that is always needed is to have:

- The `MapEntity` subclass, so objects with the intended rule are created.
- The `EntityRule` subclass, which provides data from entities to assess the interactions.
- The `EntitiesRule` subclass, which collects the data and performs the assessment for the interactions.
- The `EntitiesLayer` subclass, which instantiates the entities rule properly.
- Especially for the case of creating the four types entirely, putting them in the same folder and creating an `index.gd` is a good idea:

  ```
  # Assumming the four files are defined with these names:
  const EntitiesRule = preload("./entities_rule.gd")
  const EntityRule = preload("./entity_rule.gd")
  const MapEntity = preload("./map_entity.gd")
  const EntitiesLayer = preload("./entities_layer.gd")
  ```

So the actual logic resides in the entity rule and entities rule, but those objects are not game nodes: they're instead created by the proper
game nodes objects, which are in this case the map entity and the entities layer.

This section will describe how to define the new subclasses properly.

#### Developing the entity rule (EntityRule)

If a new entity rule subclass is needed, it must satisfy the following requirements:

1. The file must inherit from: `AlephVault__WindRose.Core.EntityRule`:

   ```
   extends AlephVault__WindRose.Core.EntitiesRule
   ```
   
   Alternatively, the file may inherit from a class that is already a child of `AlephVault__WindRose.Core.EntityRule`.

2. If a custom `_init` method is needed, it must invoke `super._init(size: Vector2i, root: bool)`. The meaning of both arguments is:

   - `root` lets the constructor determine whether the rule is a root rule or not. Being a root rule means being the one responsible of
	 forwarding signals that can be used by the entity (see the `signal rule.signals.{...}` properties in the section for general properties
	 of these objects). Usually, this argument _should receive a parameter from the new class' constructor_ but there are cases where the
	 `false` constant value should be passed instead. This is the case for when the rule has children rules, like in the `simple` rule.
   - `size` must be variable, directly or not. Either a `Vector2i` argument from the new class' constructor, or another object providing
	 the size of the entity (e.g. a `map_entity: AlephVault__WindRose.Maps.MapEntity` argument and then passing `map_entity.size` to the
	 `super._init` method). In the end, it populates the `size` property of this entity rule.

3. If children rules are instantiated as part of this new rule, it can be done on `_init` or perhaps a delayed initialization. Still,
   after the creation of that child rule (which must receive the corresponding `root=false` argument), the _on property updated_ signal
   must be forwarded upward, from the child to the parent, if the child class has properties that need to reflect their update on the
   corresponding entities rule.
   
   Let's do this with a concrete example: A new rule that has a child rule of type `AlephVault__WindRose.Contrib.Solidness.EntityRule`:
   
   ```
   var _solidness_rule: AlephVault__WindRose.Contrib.Solidness.EntityRule
   
   # Or, instead, omit this function and use: _property_was_updated
   func _forward_on_property_updated(property: String, old_value, new_value):
	   # In this case, the property name is forwarded directly.
	   # If conflicts would exist, something could be forwarded
	   # like ("solidness:" + property), rather than just (property).
	   on_property_updated.emit(property, old_value, new_value)

   func _init(
	   # In this case, rather than the size, the Solidness entity rule requires
	   # the map entity to be passes.
	   map_entity: AlephVault__WindRose.Maps.MapEntity,
	   
	   # Then, the properties. In this case, it may be sensible to forward all
	   # the properties, or only the needed ones while leaving others with
	   # some static / default values.
	   obeys_solidness: true,
	   solidness: AlephVault__WindRose.Contrib.Solidness.EntityRule.Solidness,
	   mask: String,
	   optimistic: true,
	   
	   # Finally, root should always ALWAYS be a variable.
	   root: bool
   ):
	   # First, invoke the inherited `_init` with the proper arguments.
	   super._init(map_entity.size, root)
	   
	   # Then, create the child rule.
	   _solidness_rule = AlephVault__WindRose.Contrib.Solidness.EntityRule.new(
		   map_entity, obeys_solidness, solidness,
		   mask, optimistic, false
	   )
	   
	   # Third, since the solidness rule has properties that need to be
	   # updated, this must be forwarded:
	   _solidness_rule.on_property_updated.connect(_forward_on_property_updated) # or: _property_was_updated.
   ```

4. If a new property needs to be defined, which directly affects how the entity affects the global interaction data, then
   the property must notify itself. An example with an `int` property:
   
   ```
   var _my_property: int = 0

   var my_property: int:
	   get:
		   return _my_property
	   set(value):
		   var old_value: int = _my_property
		   _my_property = value
		   # This performs de notification.
		   _property_was_updated("my_property", old_value, value)
   ```

#### Developing the entities rule (EntitiesRule)

**This is the hardest element to develop**, as most of the features are implemented here.

In order to create this rule, there are several elements to account for:

1. Ensure the class inherits from `AlephVault__WindRose.Core.EntitiesRule` or a child of it:

   ```
   extends AlephVault__WindRose.Core.EntitiesRule
   ```

2. If overriding the `_init`, it must invoke `super._init(size: Vector2i)` somewhere. In the end, it populates the `size` property
   of this entities rule. This is important, as global data will be initialized according to that `size`.

3. Most entities rules, especially those who have logic to restrict movement of entities, need to initialize the data structures
   that are needed for this logic. Typically, this involves an array with the total size, at least. And it is done in a specific
   method for this purpose. Let's explore an example for the case of each array element having an `int` data:
   
   ```
   var _data: Array[int]
   var _other_data: Array[int]
   
   func initialize_global_data():
	   _data = []
	   _data.resize(size.x * size.y)
	   _other_data = []
	   _other_data.resize(size.x * size.y)
   ```
   
   Then, have a logic to initialize / update per-cell data:
   
   ```
   func initialize_cell_data(cell: Vector2i) -> void:
	   # This can be set to a different logic but, typically,
	   # this is the same as updating the cell's data:
	   update_cell_data(cell)
   
   func update_cell_data(cell: Vector2i) -> void:
	   # Assign the data to a particular value
	   _data[cell.y * size.x + cell.x] = compute_some_value(cell.x, cell.y)
   ```

4. In order to determine whether an entity can be attached to this entities rule (and this is recommended!) override this method:

   ```
   func can_attach(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   cell: Vector2i
   ) -> bool:
	   # By default, it is:
	   # return true
	   return entity_rule is My.Namespace.EntityRule
   ```
   
   And typically also this method:
   
   ```
   func on_entity_attached(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   to_position: Vector2i
   ) -> void:
	   # Perhaps updating _other_data[(to_position.y + j) * size.x + (to_position.x + i)]
	   # for each i in 0..(entity.size.x - 1), j in 0..(entity.size.y - 1) accordingly.
	   pass
   ```
   
   And this one:
   
   ```
   func on_entity_detached(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   from_position: Vector2i
   ) -> void:
	   # Perhaps updating _other_data[(to_position.y + j) * size.x + (to_position.x + i)]
	   # for each i in 0..(entity.size.x - 1), j in 0..(entity.size.y - 1) accordingly.
	   # Ideally, doing the opposite of on_entity_attached.
	   pass
   ```

5. In order to determine whether an entity can be moved to certain direction override this method:

   ```
   func can_move(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   position: Vector2i, direction: _Direction
   ) -> bool:
	   # Returns true if the movement is allowed.
	   # return true
	   #
	   # Account for the entity_rule.size in this logic.
	   return (whether entity_rule at position can move in direction)
   ```
   
   **Ensure no data modification is done in this function, or the game logic could break entirely**

   Also, implement this (e.g. updating `_other_data`) to reflect when movement was started.
   
   ```
   func on_movement_started(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   start_position: Vector2i, end_position: Vector2i,
	   direction: AlephVault__WindRose.Utils.DirectionUtils.Direction,
	   stage: MovementStartedStage
   ) -> void:
	   # Update the data in the entities rule, e.g. `_other_data`, accounting
	   # for the start position, the end position, and the size of the entity
	   # rule. Also, perhaps the direction.
	   #
	   # The stage can be one out of the following values:
	   #
	   # Begin: This event has just started. The entity does not have its movement assigned yet.
	   # MovementAllocated: The chosen direction has been set as current movement in the entity.
	   # End: The entity was just notified (i.e. the movement started signal) about this event.
	   #
	   # Different things can be done on different stages. Developers must **ALWAYS** ensure they
	   # `match stage:` to specific stages every code block they want, or that code block would
	   # execute many times!
	   pass
   ```
   
   And, optionally, implement this (e.g. playing a mild low-frequency sound) for when the movement
   is rejected:
   
   ```
   func on_movement_rejected(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   start_position: Vector2i, end_position: Vector2i,
	   direction: AlephVault__WindRose.Utils.DirectionUtils.Direction
   ) -> void:
	   # Implement this for when the movement.
	   pass
   ```
   
   And finally, implement this (e.g. again updating `_other_data`) for when the movement is completed.
   Completing a movement means completing one single step of the movement, and it may happen that the
   movement continues as the form of a new (seamlessly continued) movement.
   
   ```
   func on_movement_finished(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   start_position: Vector2i, end_position: Vector2i, direction: _Direction,
	   stage: MovementConfirmedStage
   ) -> void:
	   # Update the data in the entities rule, e.g. `_other_data`, accounting
	   # for the start position, the end position, and the size of the entity
	   # rule. Also, perhaps the direction.
	   #
	   # The stage can be one out of the following values:
	   #
	   # Begin: This event has just started. The entity does not have its position updated yet.
	   # PositionChanged: The position of the entity has been updated.
	   # MovementCleared: The current movement has been cleared for the entity. It is, now, not moving.
	   # End: The entity was just notified (i.e. the movement finished signal) about this event.
	   #
	   # Different things can be done on different stages. Developers must **ALWAYS** ensure they
	   # `match stage:` to specific stages every code block they want, or that code block would
	   # execute many times!
	   pass
   ```

6. Also, objects could perhaps _cancel_ the current movement. Canceling movement is always allowed by
   the built-in entities rules, but there could be cases where canceling should be disables (i.e. cases
   where the movement cannot be stopped by the user due to being forced in nature, like the flow of a
   river or slippery tiles). In order to define whether an entity can cancel its current movement, this
   method must be overridden:
   
   ```
   func can_cancel_movement(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   direction: AlephVault__WindRose.Utils.DirectionUtils.Direction
   ) -> bool:
	   # Override this method to return false when the entity must
	   # not be allowed to cancel its current movement.
	   return true
   ```
   
   **Like in the case of starting a movement, do not edit any data in this method, or the game logic could break**.
   
   Then, there's a callback for when the movement is canceled:
   
   ```
   func on_movement_cancelled(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   start_position: Vector2i, reverted_position: Vector2i, direction: _Direction,
	   stage: MovementClearedStage
	) -> void:
	   # Update the data in the entities rule, e.g. `_other_data`, accounting
	   # for the start position, the end position, and the size of the entity
	   # rule. Also, perhaps the direction.
	   #
	   # The direction will be `NONE` if there was no canceled previous movement.
	   # The logic will typically return early in that case, without doing no
	   # behaviour at all. However, in some cases, it may be useful to do some
	   # sort of aesthetic behaviour even in the `NONE` case.
	   #
	   # The stage can be one out of the following values:
	   # 
	   # Begin: The cancellation is just starting.
	   # MovementCleared: The previous movement was just cleared from the entity.
	   # End: The entity's signal `on_movement_cancelled` was just triggered.
	   pass
   ```

7. Teleporting an entity is always allowed. However, there's another callback that
   could / should be implemented:
   
   ```
   func on_teleported(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   from_position: Vector2i, to_position: Vector2i,
	   stage: TeleportedStage
   ) -> void:
	   # Implement this for when an entity is teleported from one position to another
	   # position, always in the same (current) map.
	   #
	   # Update the data in the entities rule, e.g. `_other_data`, accounting
	   # for the start position, the end position, and the size of the entity
	   # rule. Also, perhaps the direction.
	   #
	   # The stage can be one out of the following values:
	   #
	   # Begin: The teleport just started.
	   # PositionChanged: The entity has new position.
	   # End: The entity's signal `on_teleported` was just truggered.
	   pass
   ```

8. Finally, certain entities rules may want to update their data when an attached
   entity changes one of their properties. There is a callback that is triggered
   when an entity emits its `on_property_updated` signal (described in the previous
   sub-section: developing the entity rule).
   
   The callback to attend a property change is:
   
   ```
   func on_property_updated(
	   entity_rule: AlephVault__WindRose.Core.EntityRule,
	   property: String, old_value, new_value
   ) -> void:
	   # Consider the old value to _undo_ the proper effects in the
	   # property update for the entity, and the new value to actually
	   # _do_ the proper effects in the property update for the entity.
	   #
	   # An example would be updating the `_other_data` according to the
	   # entity, the property, the old value and the new value.
	   pass
   ```

### Triggers

There's also a feature to pay attention to, and it is: collisions. Collisions
are provided by default by the engine, but this feature makes good use of them
so some features and setup come out of the box. The classes to pay attention
for are:

1. `AlephVault__WindRose.Triggers.EntityArea2D`: An automatic area for an entity.
2. `AlephVault__WindRose.Triggers.Trigger`: A trigger detecting those areas.

Automatic areas are, in the end, `Area2D` objects that _must be children_ of
entities (`AlephVault__WindRose.Maps.MapEntity`), and typically only one of
those objects per entity. Defining the shape is not needed, as only rectangular
shapes are supported (and this works as expected in isometric layouts as well:
they're not actually _rectangles_ because the view is isometric, but logically
they will collide according to their rectangular position) and the shape setup
is automatic considering the entity size and the map's cell size.

Other than that, they work as regular `Area2D` objects:

1. They need a proper setup of layer and mask, and users may want specific values
   there, so that collisions are not triggered under certain conditions.
2. They will cause events on other `Area2D` objects / be caused those events (i.e.
   signals like `area_entered(a: Area2D)` and so).

However, they _don't_ need to have, preliminary, any `CollisionShape2D` object to
be created for them as child, since they create and properly setup an object of
that type automatically (unless users want an explicitly extra shape object to be
added to that `Area2D` object).

Objects of type `EntityArea2D` make little to no sense if no other `Area2D` objects
are there to receive events for their collisions. Also, while tracking any other
`Area2D` object is straightforward, tracking objects that are specifically entities
(`AlephVault__WindRose.Maps.MapEntity`) _of the same map_ is not always that trivial,
since there are many events and things that may happen / changes that may occur in
the object (in terms of objects being attached / detached from maps or `Area2D` ones
which move from one entity to the other). So the `Trigger` class has special features:
it detects any `Area2D` object as always, but it forwards events related to entities
(which will be direct parents of those `Area2D` objects) that are detected, if it is
the case, and only if those entities belong to the same map.

So, in order to work with `Trigger` (`AlephVault__WindRose.Triggers.Trigger`) objects,
the developer must understand that they're actually `EntityArea2D` objects with more
features: those in charge of detecting the associated `MapEntity` objects which are
parents of any `Area2D` object being detected, if and only if those entities belong
to the same map of the trigger. Then, two options:

1. Create a subclass of the trigger and override some default methods. Consider this
   as an example (this is actually `AlephVault__WindRose.Triggers.Dummy`'s contents):

   ```
   extends AlephVault__WindRose.Triggers.Trigger

   func _entity_entered(e: AlephVault__WindRose.Maps.MapEntity):
	   print('Entity entered:', e.name)

   func _entity_staying(e: AlephVault__WindRose.Maps.MapEntity):
	   print('Entity staying:', e.name)

   func _entity_moved(e: AlephVault__WindRose.Maps.MapEntity):
	   print('Entity moved:', e.name)

   func _entity_left(e: AlephVault__WindRose.Maps.MapEntity):
	   print('Entity exited:', e.name)
   ```
   
2. Do not create a subclass, but connect callbacks to the signals with the same names,
   without underscores: `entity_entered`, `entity_staying`, `entity_moved`, `entity_left`.
   All the signals have one single parameter being the involved map entity object.

The meaning of the signals or methods (respectively - they go together) is this:

1. `entity_entered` is triggered only once per interaction. The entity started being
   detected by the `Trigger`, satisfying all the conditions: `layer` matching trigger's
   `mask`, object being in scene tree, parent being `MapEntity`, and object being in the
   same map.
2. `entity_staying` is triggered on each frame (this related to `_process` in the `Trigger`)
   after the `entity_entered`-related event.
3. `entity_moved` is triggered after the `entity_entered`-related event, but only when the
   entity finished a movement (this is ultimately implemented via the `on_movement_finished`
   signal of the entity).
4. `entity_left` is triggered only once per interaction. The entity ended being detected
   by the `Trigger` because one of the conditions stopped being satisfied (`layer` not
   matching `mask` anymore, or either of the entities is leaving the tree or the map).

The order of the events is exactly that, but `entity_event` occurs once, `entity_staying`
occurs once per frame, `entity_moved` occurs only on movement finishes, and `entity_left`
occurs only once. After this cycle, somewhere in the future, perhaps a new interaction
starts out of the entity being detected again (thus starting again with `entity_event`
and repeating the cycle in the same way).

Also, on each event, both signals and overrides can coexist. In this case:

1. The signal `entity_xxxx` is emitted first.
2. Then, the callback `_entity_xxxx` is invoked.

Finally, some notes about these triggers and areas: _They can be added statically or dynamically_,
and will start / stop working in the exact way they're added / removed from their respectively
parent objects. This works out of the box in the same way it works out of the box for the provided
features in the engine about `Area2D` objects.

The typical layout for this to work is, either statically or at runtime, have a structure like this:

```
Map: AlephVault__WindRose.Maps.Map
	EntitiesLayer: AlephVault__WindRose.Maps.Layers.EntitiesLayer (actually, a sub-type described earlier)
		SomeEntity: AlephVault__WindRose.Maps.MapEntity (actually, a sub-type described earlier)
			SomeArea2D: AlephVault__WindRose.Triggers.EntityArea2D (typically, no setup is needed)
		SomeTriggerEntity: AlephVault__WindRose.Maps.MapEntity (actually, a sub-type described earlier)
			SomeTrigger: AlephVault__WindRose.Triggers.Trigger (actually, a sub-type or with some signal callbacks)
	... other map layers (e.g. properly, the floors) ...
```

And this example, if the layer / masks are matching pairs, will work out of the box when moving the entity
across the map.

_Please note: The `MapEntity` might need some editor setup, depending on the sub-type. The same applies to
the entities layer. Also, if the chosen `Trigger` subclass has its own implementation, it might require its
own setup in the edior - However, `EntityArea2D` by itself does not need any special setup by default._

#### Teleporters

Teleporters are a special kind of triggers which cause a teleport of an object:

1. To another position in the same map.
2. Somewhere in another map.
3. Weird optional logic, like dynamically loading the map and then teleporting the object somewhere there.

In particular, teleporters are subclasses of `AlephVault__WindRose.Triggers.Teleports.Teleport`. However,
that class is abstract, to some extent, and users must define some inner behaviour there.

The first thing to understand about teleports is that in order for a teleport to work:

1. A proper target must be retrieved (this will be explained later) by the teleport trigger. It must be an
   entity inside some map.
2. An entity, the would-be teleported one, must be completely inside the area of the teleport trigger.
3. That entity must have been outside prior to the teleport, somewhere. Otherwise, if a teleport is a big
   area, an object may be found bouncing over and over between two reciprocal teleport triggers. So this
   means that an object walking inside a teleporter while being teleported to that teleporter will not be
   teleported agaun until it leaves the current teleporter's area first.

This said, the behaviour to implement in children Teleport classes is this function:

```
func _get_teleport_target() -> AlephVault__WindRose.Maps.MapEntity:
	return (something)
```

In this case, the returned value must not be null and must have a `.current_map`, meaning that it must be
in-scene and already attached to a map. If either condition is not satisfied by the returned target, then
the teleport will silently not work (which might be desirable in some game scenarios).

There's a particular, very simple, Teleport subclass: `AlephVault__WindRose.Triggers.Teleports.Teleport`.

This class provides a particular implementation of the teleport's `_get_teleport_target` method and some
editor-enabled fields to be set by the user. They come as follows:

1. Target: While the editor supports any Node2D object, this will only work when the object is a `MapEntity`
   object, valid instance, and belongs to a map (has `.current_map` distinct to null). In this case, then
   the teleport will work against this target. Otherwise, the following 3 properties will be used to tell
   what's the teleport target (it still must satisfy these conditions or the teleport will not work).
2. Target Scope Key: The key of the scope (see `AlephVault__WindRose.Maps.Scope`) this map belongs to. If this
   value is "" (empty string), then the same scope the map belogns to (if any) will be considered. Otherwise,
   the teleport target must belong to a scope which in turn belongs to the same World this trigger's map's
   scope belongs to, and has the specified key. If this is not the case, the teleport will not work.
3. Target Map Index: The index of the map the target belongs to. If this value is -1, then the same map the
   trigger belongs to will be considered. Otherwise, the teleport target must belong to a map in the same
   scope the map of this trigger belongs to, and must have the specified map index. If this is not the case,
   the teleport will not work.
4. Target Name: It is the name of the node (as in the scene editor's hierarchy) that will be the target. If
   no node satisfies this condition (given the proper Target Scope Key and Target Map Index), the teleport
   will not work. Otherwise, that node will be retrieved. Again: the node must be an in-map `MapEntity`
   object, valid instance, and belonging to the appropriate map given the lookup.

This simple teleporter is more than enough for any in-editor-created scene, and many dynamic logics. However,
this is not necessarily complete and any user may create their own Teleport subclasses where there are other
needs for that `_get_teleport_target` function.

The full set of functions that may be of interest when defining a Teleport subclass are these:

```
## This method retrieves the target of this teleport.
func _get_teleport_target() -> AlephVault__WindRose.Maps.MapEntity:
	return (something)

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

### Understanding Entity Visuals

Entity Visuals are an optional feature, enabled to ensure proper bi-dimensional z-index is used on the visual
aspect of `MapEntity` objects automatically (games will work perfectly without this feature, but this feature
enables just a minor change and almost seamless integration to update the z-index properly).

In order to enable this feature, first add a child `AlephVault__WindRose.Maps.Layers.VisualsLayer` object (it
is a `Node2D` object) to a map (a `Node2D` of type `AlephVault__WindRose.Maps.Map`). This is typically done
statically (in scene editor) or dynamically but always before the map gets called its `initialize()` method
(this typically involves instantiating each node in the structure dynamically and in the same frame, always
prior to adding the map to the scene tree).

The next step is, for each of the entities that matter (e.g. this typically does not matter for entities like
triggers, which are almost always invisible in nature). For this to work, for each entity, this can be done:

1. First, the entity should have child `AlephVault__WindRose.Maps.MapEntityVisual` objects. One or more, and
   each with different `z_index` values (this is optional but recommended). This can, actually, be changed
   at anytime and there are convenience methods (that will be described later) to do that properly, which
   account for the different moments of a `MapEntity` (i.e. being added to a map with `VisualsLayer` or not).
2. Second, ensure all the relevant maps must have their `VisualsLayer` added to them.
3. Then, add (attach) the entity to the map via the described methods in the first sections of this README.md.

This will cause the entity's visuals to be properly added and tracked (real-time updated) when the entity
moves or teleports: Their visuals are added together into a new object (related to this current entity) of type
`AlephVault__WindRose.Maps.Layers.VisualsLayer.VisualsContainer`. These containers are `Node2D` objects which
track and move (and pause / resume) all the visuals related to a single entity, and move along the current
global position of the related entity. These objects are destroyed (and their children, which are those visuals
of type `MapEntityVisual`, re-parented back to the owning `MapEntity` object) when the related `MapEntity`
object leaves the map.

In order to manipulate these objects, two methods must be accounted for:

- `func add_visual(v: AlephVault__WindRose.Maps.MapEntityVisual)` adds a new visual to an entity. For this to
  work, the visual must not have any parent at all. After calling this method, the visual becomes added to the
  entity, either as direct child of the entity (if the entity is not inside any map with `VisualsLayer`) or
  direct child of the `VisualsContainer` of that entity (if the entity is inside a map with such layer - the
  property being looked up is `(map).visuals_layer` being not null & valid instance). The added visual becomes
  visible (`visible` = `true`) if the entity is inside a map with `visuals_layer` != null. Otherwise, it
  becomes invisible (`visible` = `false`).
- `func remove_visual(v: AlephVault__WindRose.Maps.MapEntityVisual)` removes an existing visual from an entity.
  For this to work, the visual must have this entity as parent: either the entity itself, if the entity is
  not attached to a map with a `VisualsLayer` child, or from the related `VisualsContainer` otherwise. The
  removed visual becomes invisible (`visible` = `false`).

These functions are _not_ equal to trivial calls of `add_child`, `remove_child` or `reparent`. Also, these
functions can be called at any time, being the entity inside a map with `visuals_layer` != null, or not.

Also, entities can be _paused_. When they're paused, their animations will not be processed (i.e. will become
still), which means that all the attached visuals will be _paused_ as well. The methods to pause, resume, and
check the pause state are:

- `func pause()`: Pauses the current entity and related visuals container, if any. All their visuals, current or
  future, will be paused as well.
- `func resume()`: Resumes the current entity and related visuals container, if any. All their visuals, current
  or future, will be resumed as well.
- `var paused: bool`: Tells the current status of an entity: it is paused or not.

These two methods are typically not meant to be invoked by a developer directly, but there are cases where it
could make sense to invoke them.

#### Related class: VisualsLayer

The layer class is `AlephVault__WindRose.Maps.Layers.VisualsLayer`, which will use a z_index of 50, and has
the following properties and methods:

- `var initialized: bool`: Tells whether this layer is initialized or not. This is `true` if and only if this
  layer was added to a map prior to it being called `initialize()`. This layer will not work if it's not already
  initialized.
- `initialize()`: Initializes the layer, preparing the structure to do some sort of double-z-index so all the
  entities are sorted, somehow working around the z_index limitation.

It has no more public methods or properties, and will work out of the box. `initialize()` is not meant to be
arbitrarily invoked by a developer, quite like `initialize()` in the Entities Layer.

#### Related class: VisualsLayer.SubLayer

This is the first nesting level inside a VisualsLayer. It does not offer any extra method out of `Node2D` methods.
The full path is: `AlephVault__WindRose.Maps.Layers.VisualsLayer.SubLayer`.

#### Related class: VisualsLayer.VisualsContainer

The full path is: `AlephVault__WindRose.Maps.Layers.VisualsLayer.SubLayer`. This is a class tied to the `MapEntity`
class, since one instance will exist for each MapEntity instance attached to the VisualsLayer-enabled map. In this
case, this class groups all the map entity's visual objects under the same space.

It has the following methods:

- `func pause()`: Called by the map entity's `pause()` method, it freezes everything in the visual.
- `func resume()`: Called by the map entity's `resume()` method, it resumes everything in the visual.
- `func update(delta: float)`: It's called by the map entity's `_process(delta: float)` when this object exists,
  due to the map entity being added into a VisualsLayer-enabled map.
- `func bind_entity()`: Called by the map entity when it's attached to a VisualsLayer-enabled map, right after
  this container is created.

None of these methods are meant for the user to invoke them directly.

#### Related class: MapEntityVisual

The full path is `AlephVault__WindRose.Maps.MapEntityVisual`. This is the parent visual class and has many useful
methods which will be invoked by the engine appropriately:

- `func setup(e: AlephVault__WindRose.Maps.MapEntity)`: Sets this visual to the related entity. Once the entity is
  set, `_setup()` is invoked. Implement `_setup()` to have a setup logic - never override this `setup(e)` method.
  This setup occurs when this visual is added to its container (i.e. right when an object is attached to a
  VisualsLayer-enabled map).
- `func teardown(e: AlephVault__WindRose.Maps.MapEntity)`: Sets this visual to the related entity. Once the entity
  is set, `_teardown()` is invoked. Implement `_teardown()` to have a setup logic - never override this `teardown(e)`
  method. This setup occurs when this visual is added to its container (i.e. right when an object is attached to a
  VisualsLayer-enabled map).
- `func pause()`: Implementation for when the object is paused (from the downstream logic described in the previous
  classes). Implement `_pause()` to have an idempotent logic - never override this `pause()` method.
- `func resume()`: Implementation for when the object is resumed (from the downstream logic described in the previous
  classes). Implement `_resume()` to have an idempotent logic - never override this `resume()` method.
- `func update(delta: float)`: This method is invoked when the object is updated (from the `update` method in the
  container). This method is **not** invoked if the related entity is not set. Implement `_update(delta)` to have
  a logic for each cycle - never override this `update(delta)` method.
- `var paused: bool`: Tells whether this visual is paused or not.
- `var map_entity: AlephVault__WindRose.Maps.MapEntity`: Retrieves the map entity associated to this visual. This
  occurs when the setup is done and before the teardown is done.

None of these methods are meant for the user to invoke them directly.

This object extends from `Sprite2D` and the base implementation is to do nothing at all (this object implements its
own `_process` to fix its local position to `(0, 0)` but other than that no logic is implemented), which is a good
implementation for objects that do not animate in any way after having set their image (typically in a static way,
like a custom pre-fabricated scene resource file).

Developers are free (and perhaps encouraged) to create children classes out of `MapEntityVisual` for their own logic.

Typically, implementing `_pause() / _resume()` is not needed, but implementing `_update(delta)` is the critical part
of a visual (e.g. frame-by-frame animation), along with `_setup(e)` and perhaps `_teardown()`.
