extends AlephVault__WindRose__LPC.Sprites.Farm.Barn


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.physical_keycode == KEY_SPACE and not event.echo:
		if event.pressed:
			print("Spacebar pressed")
		else:
			print("Spacebar released")
