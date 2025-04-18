# AlephVault__WindRose.Rules

This section describes the components related to the LOGICAL movement of the objects inside a map. Also, this section presumes familiarity with some utilities (e.g. DirectionUtils, ExceptionUtils). They're described in their proper README.md files.

The logical movement is not necessarily related to the physical movement (this means: there's no notion of speed or hierarchy of objects). It is, however, related to the intention of movement and the allowance or management of it according to a given set of so called _rules_.

This file describes the related classes. The first part that might be noticed is that neither of these classes are _nodes_ (either base, 2D or 3D) but raw object classes, all of them located under this directory. The second part is that the behaviour is somewhat _abstract_ since some components and features are meant to be implemented later. This, because this sub-package is some sort of _base implementation_ which is, by this point, not related to any kind of scene tree / architecture so, actually, while GDScript is needed to understand this file, no understanding is needed about specific Redot / Godot API.

**Notes about errors**: There's a class that will be referred in this file: `AlephVault__WindRose.Utils.ExceptionUtils.Response`. Methods that return values of this type are characterized by two facts:

  1. They typically return a semantically meaningful value.
  2. But they can also return whether an error occurred. In that case, the error is also noticed to the developer.

## Rule pairs

Rules exist in terms of _pairs_, typically. There may be exceptions, however, but typically rules will be implemented in two (or even _three_) sides:

1. A rule related to the map.
2. A rule related to the object (entity).
3. A specific dataset related to the tiles in the map (optional).

By this point we'll talk about _entity rules_ and _entities rules_. They have different meanings: an _entities rule_ will be assigned to the map and will hold the relevant movement logic of the in-map entities. This object is _mandatory_ in a map. In contrase, an _entity rule_ is, typically, also a mandatory object assigned to each entity, and compatible in some way with the _entities rules_ assigned to the map.

However, the responsibility of these classes is asymmetric in nature: While the _entity rule_ provides data and notifies (at will) when relevant properties on it are changed, the _entities rule_ is in charge of many responsibilities:

- Vetoing and confirming addition of entities (according to their assigned entity rule and whatever is needed for setup).
- Vetoing and confirming removal of entities.
- Vetoing and implementing the start of a movement in some direction.
- Vetoing and implementing the cancellation of a movement in some direction.
- Implementing movement finalization and teleport.
- Implementing listeners for property updates in the entity.

The idea behind these responsibilities involves some tracking over the (always transient) state of the map on each of these logical changes when entities are added, removed, moved, teleported or change certain relevant properties in their rules. This is entirely up to the developer (there's no a priori limit on what can be implemented, beyond the principles of single-step movement in 4 directions that can be deemed as up / down / left or right, as always with this framework).

### Entities Manager

The entrypoint of this features is the _entities manager_. This object is related to an existing _entities rule_ and provides methods to be invoked to get the current status of objects, express intentions to move or change somehow their status, or notify that a property was changed.

So, first, the idea is to have an instance of _entities rule_, which will be described later:

```
var my_entities_rule: AlephVault__WindRose.Rules.EntitiesRule = ...get from somewhere...
var bypass = true # or false, or a lambda like (() -> bool).
var manager: AlephVault__WindRose.Rules.EntitiesManager = AlephVault__WindRose.Rules.EntitiesManager.new(my_entities_rule, bypass)
manager.initialize()
```

Once it's created, the entities rule will always remain the same for the given manager.

**Properties**

- `entities_rule: AlephVault__WindRose.Rules.EntitiesRule`: Returns the related _entities rule_ object.
- `bypass: bool`: Tells whether the checks and vetos are all bypassed or not. This means: if this property returns `true`, then each call to check movement-related actions will always be allowed. This is useful for client-server games where the client may be faulty but the server holds the truth.

**Methods**

- `get_status_for(entity_rule: _EntityRule) -> AlephVault__WindRose.Rules.EntitiesManager.EntityStatus`: Returns the status for a given entity rule, or `null` if the entity rule is not attached to this manager.
  - The resulting object has read-only properties `.position: Vector2i` for the current object's position and `.movement: AlephVault__WindRose.Utils.DirectionUtils.Direction` for the current object's movement (if `NONE`, then no current movement is being performed by the entity associated to the given entity rule).
- `initialize()`: Initializes the underlying entities rule, if it was not initialized before. This should be called as early as possible, so it's ready.
- `attach(entity_rule: AlephVault__WindRose.Rules.EntityRule, to_position: Vector2i) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: It tries to attach an entity (given by its entity rule). The response can be a successful one (containing `null` as value - in this case the entity was successfully added to the map) or a failed one with errors:
  - `r.error.code == "already_attached"` if the entity is already attached.
  - `r.error.code == "not_allowed"` if the entity was not allwed to be added (e.g. invalid entity rule or the entities rule is not initialized yet).
  - `r.error.code == "outbound"` if the attempted position puts the entity out of the map, totally or partially.
- `detach(entity_rule: AlephVault__WindRose.Rules.EntityRule) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: It tries to detach an entity (given by its entity rule). The response can be a successful one (containing `null` as value - in this case the entity was successfully removed from the map) or a failed one with errors:
  - `r.error.code == "not_attached"` if the entity is not attached.
- `movement_start(entity_rule: AlephVault__WindRose.Rules.EntityRule, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction, continued: bool) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: It tries to begin movement, according to the requested movement direction, the entity's position and the underlying logic.
  - It returns a successful response in the following scenarios:
	- With a `true` value, the movement could start successfully.
	- With a `false` value, the movement could not start because it is either already moving, the movement direction is `NONE`, or the movement was not allowed due to the rule's logic.
  - It returns a failed response in the following scenarios:
	- `r.error.code == "not_attached"` if the entity is not attached.
- `movement_cancel(entity_rule: AlephVault__WindRose.Rules.EntityRule) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: It tries to cancel the current movement.
  - It returns a successful response in the following scenarios:
	- With a `true` value, the current movement (if any) was cancelled.
	- With a `false` value, the current movement (if any) could not be cancelled.
  - It returns a failed response in the following scenarios:
	- `r.error.code == "not_attached"` if the entity is not attached.
- `movement_finish(entity_rule: AlephVault__WindRose.Rules.EntityRule) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: It tries to finish the current movement, if any.
  - It returns a successful response in the following scenarios:
	- With a `false` value if there's no current movement being finished.
	- With a `true` value if the movement was stopped.
  - It returns a failed response in the following scenarios:
	- `r.error.code == "not_attached"` if the entity is not attached.
- `teleport(entity_rule: AlephVault__WindRose.Rules.EntityRule, to_position: Vector2i, silent: bool = false) -> AlephVault__WindRose.Utils.ExceptionUtils.Response`: It tries to teleport the object to a new location. If `silent==true`, then no events will be triggered in the entity's side of the rules (still, the position will be properly reflected for the entity).
  - It returns a successful response in the following scenarios:
	- With a `null` value if the teleport was successful.
  - It returns a failed response in the following scenarios:
	- `r.error.code == "not_attached"` if the entity is not attached.
	- `r.error.code == "outbound"` if the new position, considering the entity's size, is totally or partially out of bounds.
- `property_updated(entity_rule: _EntityRule, property: String, old_value: Variant, new_value: Variant)`: Tells that the entity changed a property's value (telling the previous and new value). This is important, since it will force the underlying entities rule to update itself as also happens when starting, clearing, finishing or teleporting a movement.

### Entities-side rule

This is where _the truth_ is held. The _entities rule_ keeps information regarding to the whole map to decide whether movements can be performed / cancelled or the entities can be attached.

One typically instantiates an EntitiesRule (or rather: a subclass) like this:

```
# Typically, the constructor will remain the same: accepting a size.
# In this example, the size will be 8x6 but can be any pair of positive
# numbers (zero or negative are not accepted).
#
# Also, SomeEntitiesRule will subclass AlephVault__WindRose.Rules.EntitiesRule
var my_entities_rule: SomeEntitiesRule = SomeEntitiesRule.new(Vector2i(8, 6)) 
```

**Properties**

- `size: Vector2i`: Returns the size of the underlying map. The size is 2-dimensional and always > 0 in both x and y components.
- `initialized: bool`: Returns whether this entities rule is initialized or not. This will change when `initialize()` is invoked.

**Methods**

- `initialize() -> void`: Initializes the internal data of this entities rule. The underlying implementation is based on `initialize_global_data` and `initialize_cell_data` defined later.

**This class is meant to be overridden**. If not overridden, this class is a very dummy rule not forbidding anything and, instead, allowing every movement or cancellation. No data, by default, is held in this case. Still, the methods are:

- `initialize_global_data() -> void`: Override this to setup e.g. a global array of data or some other sort of global data.
- `initialize_cell_data(cell: Vector2i) -> void`: Override this to somehow get data applying to a specific cell (e.g. data coming from a TileMap). Ideally, the data would be updated in the structure that was initialized during `initialize_global_data`.
- `update_cell_data(cell: Vector2i) -> void`: Override this to somehow update data applying to a specific cell. The implementation is most likely the same, or similar to, `initialize_cell_data`.
- `can_attach(entity_rule: AlephVault__WindRose.Rules.EntityRule, cell: Vector2i) -> bool`: By default, this method returns `true`. Implement it to return `true` if, and only if, the entity rule:
  - Is of the expected type.
  - It has a valid set of data.
- `on_entity_attached(entity_rule: AlephVault__WindRose.Rules.EntityRule, to_position: Vector2i) -> void`: By default, empty. Implement it to update the internal data based on the fact that the entity was correctly attached to the position.
- `can_move(entity_rule: AlephVault__WindRose.Rules.EntityRule, position: Vector2i, direction: _Direction, continued: bool) -> bool`: By default, this method returns `true`. Implement it to return `true` if, and only if, the entity can start moving.
- `on_movement_started(entity_rule: AlephVault__WindRose.Rules.EntityRule, start_position: Vector2i, end_position: Vector2i, direction: _Direction, stage: MovementStartedStage) -> void`: By default, empty. Implement it to update the internal data based on the fact that the entity started its movement. This method is called 3 times, each with a different value for `stage`:
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementStartedStage.Begin`: Prior to the movement being set on the entity.
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementStartedStage.MovementAllocated`: The movement was just set on the entity.
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementStartedStage.End`: The proper callback was invoked on the entity.
- `on_movement_rejected(entity_rule: AlephVault__WindRose.Rules.EntityRule, start_position: Vector2i, end_position: Vector2i, direction: _Direction) -> void`: By default, empty. Implement it to do something if the movement was rejected (i.e. `can_move` returns `false`).
- `on_movement_finished(entity_rule: AlephVault__WindRose.Rules.EntityRule, start_position: Vector2i, end_position: Vector2i, direction: _Direction, stage: MovementConfirmedStage) -> void`: By default, empty. Implement it to update the internal data based on the fact that the entity finished its movement. This method is called 4 times, each with a different value for `stage`:
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementConfirmedStage.Begin`: Prior to the movement being finished on the entity.
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementConfirmedStage.PositionChanged`: The position was just updated on the entity.
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementConfirmedStage.MovementCleared`: The movement was just cleared from the entity.
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementConfirmedStage.End`: The proper callback was invoked on the entity.
- `can_cancel_movement(entity_rule: AlephVault__WindRose.Rules.EntityRule, direction: _Direction) -> bool`: By default, this methos returns `true`. Implement it to return `true` if, and only if, the entity's movement can be cancelled (if any).
- `on_movement_cancelled(entity_rule: AlephVault__WindRose.Rules.EntityRule, start_position: Vector2i, reverted_position: Vector2i, direction: _Direction, stage: MovementClearedStage) -> void`: By default, empty. Implement it to rollback any update in the internal data (opposite to the updates made in the `on_movement_started` callback). This method is called 3 times, each with a different value for `stage`:
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementClearedStage.Begin`: Prior to the movement being cleared on the entity.
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementClearedStage.MovementCleared`: The movement was just cleared from the entity.
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementClearedStage.End`: The proper callback was invoked on the entity.
- `on_teleported(entity_rule: AlephVault__WindRose.Rules.EntityRule, from_position: Vector2i, to_position: Vector2i, stage: TeleportedStage) -> void`: By default, empty. Implement it to clear-and-set the entity from its position and into the new position. This method is invoked 3 times, each with a different value for `stage`:
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementClearedStage.Begin`: Prior to the entity being teleported (clear data according to the entity's current position).
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementClearedStage.PositionChanged`: The teleportation occurred and the entity's position just updated (set data according to the entity's new position).
  - `AlephVault__WindRose.Rules.EntitiesRule.MovementClearedStage.End`: By this point, the teleportation just finished. If the teleportation was not silent (see the manager class), a proper callback was invoked on the entity.
- `on_property_updated(entity_rule: AlephVault__WindRose.Rules.EntityRule, property: String, old_value, new_value) -> void`: By default, empty. Implement it for when a relevant property was updated in the given entity rule. The property may be some sort of codename, rather than an actual class' property. Clear anything corresponding to the "old" value and set anything corresponding to the "new" value.
- `on_entity_detached(entity_rule: AlephVault__WindRose.Rules.EntityRule, from_position: Vector2i) -> void`: By default, empty. Implement it to update what happens after the entity was detached.

Notice how all these callback functions are related to the manager's functions. This is because an invocation in the manager is strictly related to all these veto functions (`can_`-starting ones) and callbacks (`on_`-starting ones) related to the same ability (start, finish, cancel, teleport, property update, attach or detach).

### Entity-side rule

This class holds data related to the entity. Think as if it were the logical _material_ of the entity, while the entities rule is the _space_ where the matter resides, and the manager is the _universe_ (closely related to the _space_ but also allowing consequential actions in _time_). There are two types of data that will be managed:

- Size of the entity.
- Logical data of the entity rule.

The size is constant and related to the entity. The data is custom to each implementation of entity rule.

Creating an object of this class (or even more appropriate: a subclass of this class) is simple:
	
	```
	# Provided the same constructor is respected and the entity is of 2x1:
	# A Root entity rule (with signals for the trigger_* methods described below).
	var entity_rule: MyEntityRule = MyEntityRule.new(Vector2i(2, 1))
	# Same idea.
	var entity_rule: MyEntityRule = MyEntityRule.new(Vector2i(2, 1), true)
	# No signals (used for children rules).
	var entity_rule: MyEntityRule = MyEntityRule.new(Vector2i(2, 1), false)
	```

**Properties**:

- `size: Vector2i`: Returns the size of the underlying entity. Both dimensions are > 0.
- `signals: AlephVault__WindRose.Rules.EntityRule.Signals`: Returns the signals object. Only for entity rules which are root.

**Methods**:

- `trigger_on_attached(entities_manager: AlephVault__WindRose.Rules.EntitiesManager, to_position: Vector2i)`: A callback telling that the entity (rule) has successfully been added to a map (given by its manager).
- `trigger_on_detached()`: A callback telling that the entity (rule) has successfully been removed from a map (given by its entities rule).
- `trigger_on_movement_rejected(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: A callback telling that the entity's intention for movement has been rejected due to the entities rule's logic.
- `trigger_on_movement_started(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: A callback telling that the entity's intention for movement has been accepted due to the entities rule's logic.
- `trigger_on_movement_finished(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: A callback telling that the entity finished moving.
- `trigger_on_movement_cleared(from_position: Vector2i, reverted_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: A callback telling that the entity's current movement was reverted (this might be a noop if the direction is `NONE`).
- `trigger_on_teleported(from_position: Vector2i, to_position: Vector2i)`: A callback telling that the entity was just teleported.
- `_property_was_updated(property: String, old, new)`: A method providing a way to notify the update of an internal property so at some point the manager is reached and `on_property_updated(entity_rule, property, old, new)` is invoked. After it, the user must invoke this method, typically, in the `set(value):` part of a property after it's successfully updated so the bubbling starts.

**Signals**

- `on_property_updated(property: String, old, new)`: Triggered by `_property_was_updated` method, usually when a rule's property changes.

Notice how all the `trigger_` methods are so, in the end, the entity gets notified from an external place (i.e. the _manager_). We can think about these methods as if they were _inbound_ methods or callbacks. In contrast, `_property_was_updated` is different: its intention is not to receive a notification but to _serve_ as a notifier itself when a property in this entity rule object was changed. This is, however, chosen at user's discretion.

The `trigger_*` methods trigger the matching signals available in the `signals` object, if the entity rule was created as root. If it's not a root, then these methods do nothing.

### Entity-side rule's signals

The `signals` object (`AlephVault__WindRose.Rules.EntityRule.Signals`) has the following signals:

- `on_attached(entities_manager: AlephVault__WindRose.Rules.EntitiesManager, to_position: Vector2i)`: Triggered when the entity rule was added to an entities rule (space).
- `on_detached()`: Triggered when the entity rule was removed from an entities rule (space).
- `on_movement_started(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: Triggered when the entity started moving.
- `on_movement_rejected(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: Triggered when the movement attempt was rejected.
- `on_movement_finished(from_position: Vector2i, to_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: Triggered when the current movement was finished.
- `on_movement_cancelled(from_position: Vector2i, reverted_position: Vector2i, direction: AlephVault__WindRose.Utils.DirectionUtils.Direction)`: Triggered when a current movement was cancelled.
- `on_teleported(from_position: Vector2i, to_position: Vector2i)`: Triggered when the object was teleported.

These signals are listened by the respective _entity_ to allow further end-user processing.
