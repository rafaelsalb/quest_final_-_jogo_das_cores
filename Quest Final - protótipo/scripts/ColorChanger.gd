extends Area2D


export(bool) var clear_before_add
export(int, "Red", "Yellow", "Blue", "Orange", "Purple", "Green", "White", "Black") var color_name

var disabled: bool = false


func _ready():
	$Sprite.modulate = PColors.COLORS[color_name]
	$Label.text = PColors.COLOR_NAMES[color_name]
	connect("body_entered", self, "_on_ColorChanger_area_entered")
	Global.connect("lights_off", self, "on_lights_off")
	Global.connect("lights_on", self, "on_lights_on")


func _on_ColorChanger_area_entered(body):
	if body.name == "Player" and not disabled:
		if clear_before_add:
			body.change_color(color_name)
		else:
			body.add_color(color_name)


func on_lights_off():
	disabled = true

func on_lights_on():
	disabled = false
