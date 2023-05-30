extends Node2D


func _on_DeathArea_body_entered(body):
	if body.name == "Player":
		body.die()
