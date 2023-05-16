extends StaticBody2D

export(int, "Red", "Yellow", "Blue", "Orange", "Purple", "Green", "White", "Black") var color_name
onready var allowed_color: int = color_name


func _ready():
	Global.connect("lights_off", self, "on_lights_off")
	Global.connect("lights_on", self, "on_lights_on")

	for i in range(7):
		set_collision_layer_bit(i, true)
		set_collision_mask_bit(i, true)
	set_collision_layer_bit(allowed_color, false)
	set_collision_mask_bit(allowed_color, false)

	for i in range(7):
		print(name, " ", i, " ", get_collision_layer_bit(i))
	
	$Sprite.modulate = PColors.COLORS[color_name]
	$Sprite2.modulate = PColors.COLORS[color_name]
	$Particles2D.process_material.color = PColors.COLORS[color_name]
	$Particles2D2.process_material.color = PColors.COLORS[color_name]
	
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


func _process(_delta):
	$Label.visible = Global.debug


func change_color(color_i: int) -> void:
	var color = PColors.PColors.new(color_i)
	$Sprite.modulate = color.color
	$Sprite2.modulate = color.color
	
	for i in range(8):
		set_collision_layer_bit(i, true)
		set_collision_mask_bit(i, true)
	if color_i != PColors.BLACK:
		set_collision_layer_bit(color.name, false)
		set_collision_mask_bit(color.name, false)

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
	$Sprite.modulate = PColors.COLORS[PColors.WHITE]
	$Sprite.get_material().set_shader_param("invert", true)


func on_lights_on():
	print(1)
	$Sprite.modulate = PColors.COLORS[allowed_color]
	$Sprite.get_material().set_shader_param("invert", false)
