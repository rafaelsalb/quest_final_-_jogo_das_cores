extends KinematicBody2D


export var GRAVITY: int = 1
export(bool) var AVOID_FALL = true

const mov_dir: Vector2 = Vector2()

onready var coll_shape = get_node("CollisionShape2D")
var horizontal_dir = 1


func _physics_process(delta: float) -> void:
	mov_dir.x = horizontal_dir * 15
	
	if is_on_wall():
		horizontal_dir *= -1
		$RayCast2D.set_cast_to(Vector2(32 * horizontal_dir, 32))
		position.x += coll_shape.shape.get_extents().x / 2 * horizontal_dir
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	if AVOID_FALL and $RayCast2D.get_collider() == null:
		horizontal_dir *= -1
		$RayCast2D.set_cast_to(Vector2(32 * horizontal_dir, 32))
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	
	if not is_on_floor():
		mov_dir.y += GRAVITY
	
	move_and_slide(mov_dir * 10, Vector2.UP)


func _on_Kill_body_entered(body):
	if body.name == "Player":
		body.die()


func die():
	$CollisionShape2D.queue_free()
	$Kill/CollisionShape2D.queue_free()
	$AnimatedSprite.stop()
	set_physics_process(false)
	$DeathTimer.start()
	pass


func _on_DeathTimer_timeout():
	queue_free()
