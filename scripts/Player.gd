extends KinematicBody2D


export var GRAVITY: int = 1

var mov_dir: Vector2 = Vector2()
const JUMP_STRENGTH: int = 40

onready var animation_player = get_node("AnimatedSprite")
onready var idle_collision = get_node("IdleCollisionShape")
onready var jump_collision = get_node("JumpCollisionShape")
onready var run_collision = get_node("RunCollisionShape")

var horizontal_dir: float
var color
var points
var finished_game = false


func _ready() -> void:
	Serial.connect("A_pressed", self, "on_A_pressed")
	Serial.connect("B_pressed", self, "on_B_pressed")
	Serial.connect("Start_pressed", self, "on_Start_pressed")
	Serial.connect("analogX_neutral", self, "on_analogX_neutral")
	Serial.connect("analog_left", self, "on_analog_left")
	Serial.connect("analog_right", self, "on_analog_right")
	Serial.connect("analog_up", self, "on_analog_up")
	Serial.connect("analog_down", self, "on_analog_down")
	
	
	points = 3
	mov_dir.y = 0
	color = PColors.PColors.new(Global.curr_color)
	change_color(color.name)
	Global.connect("lights_off", self, "on_lights_off")
	Global.connect("lights_on", self, "on_lights_on")
	
	$HUD/Control/LivesCountLabel.text = str(Global.lives)


func _unhandled_input(_event):
	horizontal_dir = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	mov_dir.x = horizontal_dir * 20
	
	if Input.is_action_pressed("up") and is_on_floor():
		mov_dir.y = -JUMP_STRENGTH
	
	if Global.debug:
		if Input.is_action_just_pressed("clear_color"):
			change_color(PColors.BLACK)
		if Input.is_action_just_pressed("white_color"):
			change_color(PColors.WHITE)
	
		if Input.is_action_just_pressed("take_damage"):
			take_damage(1, 1)
	
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
	if Global.finished_game:
		if not finished_game:
			finished_game = true
			$AnimatedSprite.get_material().set_shader_param("finished", true)
			$HUD/ColorRect.visible = false


func change_color(color_i: int) -> void:
	color = PColors.PColors.new(color_i)
	Global.curr_color = color_i
	$HUD/Control/CurrColorLabel.text = PColors.COLOR_NAMES[color.name]
	$HUD/Control/LeftCorner.modulate = color.color
	$HUD/Control/LifeCounter0.modulate = color.color
	$HUD/Control/LifeCounter1.modulate = color.color
	$Damage.process_material.color = color.color
	
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
	change_color(color.name)


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
#	$HUD/BlackAndWhiteEffect.visible = true
#	$CanvasModulate.visible = true
#	$Light2D.enabled = true
	
	$AnimationPlayer.play("light_off")
	
	$AnimatedSprite.modulate = PColors.NAME_TO_Color.get(PColors.BLACK)
	
	for i in range(8):
		set_collision_layer_bit(i, false)
		set_collision_mask_bit(i, false)
	
	$AnimatedSprite.modulate = PColors.COLORS[PColors.WHITE]
	$AnimatedSprite.get_material().set_shader_param("invert", true)
	
	update_label()


func on_lights_on():
#	$HUD/BlackAndWhiteEffect.visible = false
#	$CanvasModulate.visible = false
#	$Light2D.enabled = false
	change_color(color.name)
	$AnimationPlayer.play_backwards("light_off")

	$AnimatedSprite.modulate = color.color
	$AnimatedSprite.get_material().set_shader_param("invert", false)


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


func take_damage(dmg, dir):
	if $DamageCooldownTimer.is_stopped():
		$DamageCooldownTimer.start()
		if points - dmg < 0:
			die()
			pass
		
		update_points(-dmg)
		$Damage.emitting = true
	#	mov_dir.x = dir * 10.0
		mov_dir.y = -JUMP_STRENGTH / 2.0


func die():
	animation_player.play("die")
	idle_collision.disabled = true
	jump_collision.disabled = true
	run_collision.disabled = true
	update_lives(-1)
	queue_free()
	Global.check_game_over()


func update_points(points_i):
	points = clamp(points + points_i, 0, 3)
	$HUD/Control/LifeCounter0.rect_size.x = 32 * (3 - points)
	$HUD/Control/LifeCounter1.rect_size.x = 32 * points


func update_lives(lives_i):
	Global.lives += lives_i
	$HUD/Control/LivesCountLabel.text = str(Global.lives)


func _on_Stomp_body_entered(body):
	if body.name.left(5) == "Enemy":
		mov_dir.y = -JUMP_STRENGTH / 2.0
		body.die()
		update_points(1)
		$ImpactSFX.play()


func _on_DeathZone_area_entered(area):
	if area.name.left(len("Espinhos")) == "Espinhos":
		take_damage(1, 0)


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


func _on_DarkAreaScanner_area_entered(area):
	Global.set_is_player_in_dark_area(true)


func _on_DarkAreaScanner_area_exited(area):
	Global.set_is_player_in_dark_area(false)


func impulse(strength):
	mov_dir.y = -strength


func _on_DeathZone_body_entered(body):
	if body.name.left(len("Projectile")) == "Projectile" or body.name.left(len("@Projectile")) == "@Projectile" and body.active:
		take_damage(1, body.mov_dir.x)
		body.explode()


func _on_DamageCooldownTimer_timeout():
	pass


func on_A_pressed():
	if is_on_floor():
		mov_dir.y = -JUMP_STRENGTH


func on_B_pressed():
#	if is_on_floor():
#		mov_dir.y = -JUMP_STRENGTH
	pass


func on_Start_pressed():
	pass
#	Global.switch_pause()
#	$HUD.switch_pause()


func on_analog_left():
	horizontal_dir = -1
	mov_dir.x = horizontal_dir * 20


func on_analogX_neutral():
	horizontal_dir = 0
	mov_dir.x = horizontal_dir * 20


func on_analog_right():
	horizontal_dir = 1
	mov_dir.x = horizontal_dir * 20


func on_analog_up():
	if is_on_floor():
		mov_dir.y = -JUMP_STRENGTH


func on_analogY_neutral():
	pass


func on_analog_down():
	pass
