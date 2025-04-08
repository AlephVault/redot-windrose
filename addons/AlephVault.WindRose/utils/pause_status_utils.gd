extends Object

## This enum defines the possible pause statuses for entities.
## Controls whether movement and animations are allowed.
enum PauseStatus {
	NONE = 0,
	IN_PLACE = 1,
	FROZEN = 2
}

## Tells whether the status corresponds to a paused status
## or a non-paused status.
static func is_paused(status: PauseStatus) -> bool:
	return status != PauseStatus.NONE

## Tells whether the status corresponds to an animation-paused
## status or a non-animation-paused status.
static func is_animation_paused(status: PauseStatus) -> bool:
	return status == PauseStatus.FROZEN
