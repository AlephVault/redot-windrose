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
  Entities in this map will have their positions constrained by these dimensions.
- `gizmo_x_axis_color`, `gizmo_y_axis_color` and `gizmo_grid_color`: These properties only serve for debugging
  purposes in the editor, since they provide a grid ad hoc to track the objects even before the tilemaps have their
  cells properly filled. All these properties are of type `Color`.
- `floor_layer: AlephVault__WindRose.Maps.Layers.FloorLayer`: Returns the floor layer for the map. This layer is
  read-only and set on initialization, by detecting a direct child being of this type.
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

### Blocking rule-related properties and methods

### Solidness rule-related properties and methods

### Neighbours rule-related properties and methods

### Navigability rule-related properties and methods

### Simple rule-related properties and methods

### Advanced development

