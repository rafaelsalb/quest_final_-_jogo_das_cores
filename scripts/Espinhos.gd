extends Area2D


func _ready():
	connect("body_entered", self, "_on_Espinhos_body_entered")


func _on_Espinhos_body_entered(body):
	if body.name == "Player":
		body.die()
