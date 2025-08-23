extends AlephVault__WindRose.Triggers.Trigger


func _entity_entered(e: AlephVault__WindRose.Maps.MapEntity):
	print('Entity entered:', e.name)

func _entity_staying(e: AlephVault__WindRose.Maps.MapEntity):
	print('Entity staying:', e.name)

func _entity_moved(e: AlephVault__WindRose.Maps.MapEntity):
	print('Entity moved:', e.name)

func _entity_left(e: AlephVault__WindRose.Maps.MapEntity):
	print('Entity entered:', e.name)
