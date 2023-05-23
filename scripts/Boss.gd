extends KinematicBody2D


export var GRAVITY: int = 0

const mov_dir: Vector2 = Vector2()

onready var coll_shape = get_node("CollisionShape2D")
onready var projectile = preload("res://scenes/Projectile.tscn")
var horizontal_dir = 1
var aiming_at = Vector2.ZERO


func _physics_process(delta: float) -> void:
	mov_dir.x = horizontal_dir * 15
	
	if is_on_wall():
		horizontal_dir *= -1
		position.x += coll_shape.shape.get_extents().x / 20 * horizontal_dir
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	move_and_slide(mov_dir * 10, Vector2.UP)

	if Global.debug:
		if Input.is_action_just_released("kill_enemies"):
			die()


func _on_Kill_body_entered(body):
	if body.name == "Player":
		body.die()


func die():
	$CollisionShape2D.queue_free()
	$Kill/CollisionShape2D.queue_free()
	$AnimatedSprite.stop()
	$AnimatedSprite.visible = false
	$AnimatedSprite2.play("default")
	$AnimatedSprite2.visible = true
	set_physics_process(false)
	$DeathTimer.start()


func _on_DeathTimer_timeout():
	queue_free()


func _on_Timer_timeout():
	var projectile_instance = projectile.instance()
	add_child(projectile_instance)
	projectile.mov_dir = aiming_at
