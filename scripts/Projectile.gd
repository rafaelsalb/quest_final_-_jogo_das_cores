extends KinematicBody2D


const SPEED = 50
var mov_dir = Vector2.ZERO


func _physics_process(_delta):
	move_and_slide(mov_dir * SPEED)
