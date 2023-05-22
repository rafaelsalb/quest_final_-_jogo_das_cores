extends Area2D


var checked = false


func _on_CheckPoint_body_entered(body):
	if body.name == "Player" and not checked:
		checked = true
		Global.checkpoint_checked(position)
		$UncheckedSprite.visible = false
		$CheckedSprite.visible = true
		$Light2D.enabled = true
