extends Area2D


export(int, "Menu", "Level 1", "Level 2", "Level 3") var NEXT_LEVEL


func _on_FinishLine_body_entered(body):
	if body.name == "Player":
		Global.change_level(NEXT_LEVEL)
