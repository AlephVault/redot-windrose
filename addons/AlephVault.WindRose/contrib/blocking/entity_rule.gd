extends AlephVault__WindRose.Core.EntityRule
## This is the implementation of an entity rule
## which can have its path blocked by a static
## obstacle on any of its points. This means that
## an entity rule of this class cannot move in a
## given direction if any upcoming cell in that
## direction (considering width or height of the
## entity) is blocking / is an obstacle.
##
## This entity rule class, on itself, add no extra
## implementation to the logic.
