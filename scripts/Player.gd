extends KinematicBody2D


export var GRAVITY: int = 1

const mov_dir: Vector2 = Vector2()
const JUMP_STRENGTH: int = 40

onready var animation_player = get_node("AnimatedSprite")
onready var idle_collision = get_node("IdleCollisionShape")
onready var jump_collision = get_node("JumpCollisionShape")
onready var run_collision = get_node("RunCollisionShape")

var horizontal_dir: float
var color


func _ready() -> void:
	mov_dir.y = 0
	color = PColors.PColors.new(Global.curr_color)
	change_color(color.name)
	Global.connect("lights_off", self, "on_lights_off")
	Global.connect("lights_on", self, "on_lights_on")


func _unhandled_input(_event):
	horizontal_dir = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	mov_dir.x = horizontal_dir * 20
	
	if Input.is_action_pressed("up") and is_on_floor():
		mov_dir.y = -JUMP_STRENGTH
	
	if Input.is_action_just_pressed("clear_color"):
		change_color(PColors.BLACK)
	if Input.is_action_just_pressed("white_color"):
		change_color(PColors.WHITE)
	
	for i in range(1, 9):
		if Input.is_action_just_pressed("num_" + str(i)):
			change_color(i - 1)


func _physics_process(_delta: float) -> void:
	if is_on_ceiling():
		mov_dir.y = -mov_dir.y / 2.0
	
	if not is_on_floor():
		mov_dir.y += GRAVITY
	
	move_and_slide(mov_dir * 10, Vector2.UP)


func _process(_delta: float) -> void:
	$Label.visible = Global.debug
	update_animation()


func change_color(color_i: int) -> void:
	color = PColors.PColors.new(color_i)
	Global.curr_color = color_i
	$HUD/Control/CurrColorLabel.text = PColors.COLOR_NAMES[color.name]
	
	if color_i != PColors.BLACK:
		$AnimatedSprite.modulate = color.color
		$HUD/ColorRect.color = color.color
		$AnimatedSprite.get_material().set_shader_param("invert", false)
	else:
		$AnimatedSprite.modulate = PColors.COLORS[PColors.WHITE]
		$HUD/ColorRect.color = PColors.COLORS[PColors.BLACK]
		$AnimatedSprite.get_material().set_shader_param("invert", true)
	
	for i in range(8):
		set_collision_layer_bit(i, false)
		set_collision_mask_bit(i, false)
	if color_i != PColors.BLACK:
		set_collision_layer_bit(color.name, true)
		set_collision_mask_bit(color.name, true)
	
	update_label()


func add_color(color_i: int) -> void:
	color = color.add(PColors.PColors.new(color_i))
	Global.curr_color = color.name
	$HUD/Control/CurrColorLabel.text = PColors.COLOR_NAMES[color.name]
	
	$AnimatedSprite.modulate = color.color
	$HUD/ColorRect.color = color.color
	
	for i in range(8):
		set_collision_layer_bit(i, false)
		set_collision_mask_bit(i, false)
	set_collision_layer_bit(color.name, true)
	set_collision_mask_bit(color.name, true)
	
	update_label()


func update_label():
	var text = ""
	for i in range(4):
		if get_collision_layer_bit(i):
			text += "1 "
		else:
			text += "0 "
	text += "\n"
	for i in range(4, 8):
		if get_collision_layer_bit(i):
			text += "1 "
		else:
			text += "0 "
	
	$Label.text = text


func on_lights_off():
	print(0)
	
	$AnimatedSprite.modulate = PColors.NAME_TO_Color.get(PColors.BLACK)
	$HUD/ColorRect.color = color.color
	
	for i in range(8):
		set_collision_layer_bit(i, false)
		set_collision_mask_bit(i, false)
	
	update_label()


func on_lights_on():
	print(1)
	change_color(color.name)


func update_animation():
	if horizontal_dir > 0:
		animation_player.flip_h = false
	elif horizontal_dir < 0:
		animation_player.flip_h = true
	if is_on_floor():
		if horizontal_dir == 0:
			animation_player.play("idle")
			update_collision("idle")
		elif abs(horizontal_dir) > 0:
			idle_collision.disabled = true
			jump_collision.disabled = true
			run_collision.disabled = false
			animation_player.play("run")
			update_collision("run")
	else:
		idle_collision.disabled = true
		jump_collision.disabled = false
		run_collision.disabled = true
		if mov_dir.y <= 0:
			animation_player.play("jump")
		else:
			animation_player.play("fall")
		update_collision("jump")


func die():
	animation_player.play("die")
	idle_collision.disabled = true
	jump_collision.disabled = true
	run_collision.disabled = true
	Global.lives -= 1
	queue_free()
	Global.check_game_over()


func _on_Stomp_body_entered(body):
	if body.name.left(5) == "Enemy":
		body.die()


func _on_DeathZone_area_entered(area):
	if area.name.left(len("Espinhos")) == "Espinhos":
		die()


func update_collision(action: String):
	if action == "idle":
		idle_collision.disabled = false
		$DeathZone/IdleCollisionShape.disabled = false
		jump_collision.disabled = true
		$DeathZone/JumpCollisionShape.disabled = true
		run_collision.disabled = true
		$DeathZone/RunCollisionShape.disabled = true
	elif action == "jump":
		idle_collision.disabled = true
		$DeathZone/IdleCollisionShape.disabled = true
		jump_collision.disabled = false
		$DeathZone/JumpCollisionShape.disabled = false
		run_collision.disabled = true
		$DeathZone/RunCollisionShape.disabled = true
	elif action == "run":
		idle_collision.disabled = true
		$DeathZone/IdleCollisionShape.disabled = true
		jump_collision.disabled = true
		$DeathZone/JumpCollisionShape.disabled = true
		run_collision.disabled = false
		$DeathZone/RunCollisionShape.disabled = false
