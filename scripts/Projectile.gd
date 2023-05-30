extends KinematicBody2D


var mov_dir: Vector2 = Vector2.ZERO
var active: bool = true

const SPEED: float = 200.0


func _physics_process(delta):
	move_and_slide(mov_dir * SPEED)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func explode():
	$DeathTimer.start()
	set_collision_layer_bit(12, false)
	set_collision_mask_bit(12, false)
	$CollisionShape2D.set_deferred("disabled", true)
	mov_dir = Vector2.ZERO
	active = false


func _on_DeathTimer_timeout():
	queue_free()
