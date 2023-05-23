extends Area2D


var is_on = false

func _on_LightSwitch_body_entered(body):
	if not Global.is_player_in_dark_area and body.name == "Player" and $Cooldown.is_stopped():
		is_on = not is_on
		$OnSprite.visible = not $OnSprite.visible
		$OffSprite.visible = not $OffSprite.visible
		$Cooldown.start()
		Global.set_lights(is_on)
