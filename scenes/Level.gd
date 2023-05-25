extends Node2D


var is_boss_alive: bool = true


func _process(_delta):
	if is_boss_alive:
		$Boss.aim_at($Player.position)
