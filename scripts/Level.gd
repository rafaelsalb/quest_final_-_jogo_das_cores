extends Node2D


func _ready():
	if Global.checkpoint_checked:
		$Player.move_and_slide(Global.checkpoint_pos, Vector2.UP)
