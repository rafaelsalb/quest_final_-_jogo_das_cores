extends Control


var time = 0


func _on_JogarButton_button_up():
	Global.change_level(1)


func _on_SairButton_button_up():
	get_tree().quit()


func _process(delta):
	$MarginContainer/HBoxContainer/CenterContainer/Sprite.modulate = Color.from_hsv(0.5 + 0.5 * cos(time), 1.0, 1.0)
	time += delta / 2.0
