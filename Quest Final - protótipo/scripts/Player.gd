extends KinematicBody2D


export var GRAVITY: int = 1

const mov_dir: Vector2 = Vector2()
const JUMP_STRENGTH: int = 40

var horizontal_dir: float
var color: PColors.PColors = PColors.PColors.new(PColors.WHITE)


func _ready() -> void:
	mov_dir.y = 0
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
			change_color(PColors.COLORS[i-1])


func _physics_process(_delta: float) -> void:
	if is_on_ceiling():
		mov_dir.y = -mov_dir.y / 2.0
	
	if not is_on_floor():
		mov_dir.y += GRAVITY
	
	move_and_slide(mov_dir * 10, Vector2.UP)


func _process(_delta: float) -> void:
	$Label.visible = Global.debug


func change_color(color_i: int) -> void:
	color = PColors.PColors.new(color_i)
	$Sprite.modulate = color.color
	$CanvasLayer/ColorRect.color = color.color
	
	for i in range(8):
		set_collision_layer_bit(i, false)
		set_collision_mask_bit(i, false)
	if color_i != PColors.BLACK:
		set_collision_layer_bit(color.name, true)
		set_collision_mask_bit(color.name, true)
	
	update_label()


func add_color(color_i: int) -> void:
	color = color.add(PColors.PColors.new(color_i))
	
	$Sprite.modulate = color.color
	$CanvasLayer/ColorRect.color = color.color
	
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
	
	$Sprite.modulate = PColors.NAME_TO_Color.get(PColors.BLACK)
	$CanvasLayer/ColorRect.color = color.color
	
	for i in range(8):
		set_collision_layer_bit(i, false)
		set_collision_mask_bit(i, false)
	
	update_label()


func on_lights_on():
	print(1)
	change_color(color.name)
