extends KinematicBody2D


export var GRAVITY: int = 1

const mov_dir: Vector2 = Vector2()
const JUMP_STRENGTH: int = 40

onready var animation_player = get_node("AnimatedSprite")
onready var jump_sound = get_node("JumpAudio")
onready var oneup_sound = get_node("OneUpAudio")
onready var stomp_sound = get_node("StompAudio")
onready var raycast = get_node("RayCast2D")

var horizontal_dir: float
var log_n = 0
var points = 0
var dead = false
var crouching = false
var color: Color = Color(0, 0, 0)

signal died
signal death_audio_finished
signal enter_pipe(pipe)


func _ready() -> void:
	mov_dir.y = 0


func _unhandled_input(_event):
	horizontal_dir = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	mov_dir.x = horizontal_dir * 20
	crouching = false
	
	if Input.is_action_pressed("up") and is_on_floor():
		jump_sound.play()
		mov_dir.y = -JUMP_STRENGTH
	elif Input.is_action_pressed("down"):
		var collider = raycast.get_collider()
		if collider != null and collider.name.left(4) == "Pipe":
			emit_signal("enter_pipe", collider)
		elif is_on_floor() and horizontal_dir == 0:
			crouching = true


func _physics_process(_delta: float) -> void:
	if is_on_ceiling():
		mov_dir.y = -mov_dir.y / 2.0
	
	if not is_on_floor():
		mov_dir.y += GRAVITY
	
	if not dead:
		if crouching:
			$CollisionShape2D.disabled = true
			$CrouchingCollision.disabled = false
			mov_dir.x = 0
		else:
			$CollisionShape2D.disabled = false
			$CrouchingCollision.disabled = true
	
	update_animation()
	
	move_and_slide(mov_dir * 10, Vector2.UP)


func _process(_delta: float) -> void:
	var r = get_global_mouse_position().x / 1280.0
	var g = get_global_mouse_position().y / 720.0
	if points >= 1000:
		one_up()
	animation_player.modulate = color


func update_animation() -> void:
	if horizontal_dir == -1:
		animation_player.flip_h = true
	elif horizontal_dir == 1:
		animation_player.flip_h = false
	if is_on_floor():
		if horizontal_dir == 0:
			animation_player.play("idle_0")
		elif abs(horizontal_dir) > 0:
			animation_player.play("walk_0")
	else:
		animation_player.play("jump_0")
	
	if crouching:
		animation_player.play("crouch_0")


func die():
	dead = true
	horizontal_dir = 0
	mov_dir.x = 0
	mov_dir.y -= JUMP_STRENGTH * 2
	animation_player.visible = false
	$DeathAnimation.visible = true
	$DeathAnimation.play("die")
	get_node("DeathAudio").play()
	z_index = 2
	$CollisionShape2D.queue_free()
	$CrouchingCollision.queue_free()
	$Stomp.queue_free()
	
	set_process_unhandled_input(false)
	emit_signal("died")


func _on_Stomp_body_entered(body):
	if body.name.left(6) == "Goomba" and mov_dir.y != 0:
		stomp_sound.play()
		mov_dir.y = -20
		points += 100
		body.die()


func one_up():
	points -= 1000 if points >= 1000 else 0
	oneup_sound.play()


func _on_DeathAudio_finished():
	emit_signal("death_audio_finished")


func change_color(color_i):
	color = color_i
	
	if color.r == 1:
		set_collision_layer_bit(0, true)
	else:
		set_collision_layer_bit(0, false)
	if color.g == 1:
		set_collision_layer_bit(1, true)
	else:
		set_collision_layer_bit(1, false)
	if color.b == 1:
		set_collision_layer_bit(2, true)
	else:
		set_collision_layer_bit(2, false)
	
	for i in range(3):
		print(get_collision_layer_bit(i))
