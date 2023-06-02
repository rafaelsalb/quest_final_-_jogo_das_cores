extends KinematicBody2D


export var GRAVITY: int = 0

const mov_dir: Vector2 = Vector2()

onready var coll_shape = get_node("CollisionShape2D")
onready var projectile = preload("res://scenes/Projectile.tscn")
onready var possible_colors = PColors.COLORS.duplicate()
var active: bool = false
var horizontal_dir = 1
var aim_angle: float
var stunned: bool = false
var curr_color: int = 0


signal damaged


func _ready():
	set_physics_process(false)
	set_process(false)
	randomize()
	possible_colors.pop_back()
	possible_colors.pop_back()
	possible_colors.shuffle()
	print(possible_colors)
	curr_color = PColors.Color_TO_NAME[possible_colors[0]]
	for child in $Indicators.get_children():
		child.modulate = PColors.COLORS[curr_color]


func _physics_process(_delta: float) -> void:
	if not stunned:
		mov_dir.x = horizontal_dir * 15
		
		if is_on_wall():
			horizontal_dir *= -1
			position.x += coll_shape.shape.get_extents().x / 20 * horizontal_dir
			$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		
		move_and_slide(mov_dir * 10, Vector2.UP)

	if Global.debug:
		if Input.is_action_just_released("kill_enemies"):
			die()


func aim_at(target):
	aim_angle = atan2(
		target.y - position.y,
		target.x - position.x
	)
	$CannonSprite.rotation = aim_angle
	$Position2D.position = Vector2(
		48 * cos(aim_angle),
		48 * sin(aim_angle)
	)
	$REye.rotation = aim_angle
	$LEye.rotation = aim_angle


func die():
	print("ganhaste!")
	get_parent().is_boss_alive = false
	Global.finished_game = true
	queue_free()


func shoot():
	if active:
		var projectile_instance = projectile.instance()
		get_parent().add_child(projectile_instance)
		projectile_instance.mov_dir = Vector2(
			cos(aim_angle),
			sin(aim_angle)
		)
		projectile_instance.global_position = $Position2D.global_position
		print(projectile_instance.name)


func _on_DeathTimer_timeout():
	queue_free()


func _on_ShootCooldown_timeout():
	if not stunned:
		shoot()


func _on_KillPlayerArea_body_entered(body):
	if body.name == "Player":
		body.take_damage(1, horizontal_dir)


func _on_WeakSpotArea_body_entered(body):
	if body.name == "Player" and $DamageCooldown.is_stopped() and body.color.name == curr_color:
		print(possible_colors)
		body.impulse(60)
		$BounceSFX.play()
		body.update_points(1)
		body.change_color(PColors.WHITE)
		$DamageCooldown.start()
		stunned = true
		
		if possible_colors.size() > 1:
			possible_colors.pop_front()
			$Indicators.get_children()[-1].queue_free()
			if $Indicators.get_children().size() > 0:
				emit_signal("damaged")
		else:
			die()


func _on_DamageCooldown_timeout():
	stunned = false
	$WeakSpotArea/CollisionShape2D.disabled = false
	curr_color = PColors.Color_TO_NAME[possible_colors[0]]
	for child in $Indicators.get_children():
		child.modulate = PColors.COLORS[curr_color]
