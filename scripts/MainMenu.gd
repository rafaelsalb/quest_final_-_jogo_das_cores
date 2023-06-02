extends Control


var time = 0


func _on_JogarButton_button_up():
	Global.lives = 3
	Global.change_level(0)


func _on_SairButton_button_up():
	get_tree().quit()


func _process(delta):
	$MarginContainer/HBoxContainer/CenterContainer/Sprite.modulate = Color.from_hsv(0.5 + 0.5 * cos(time), 1.0, 1.0)
	$MarginContainer/HBoxContainer/VBoxContainer/Label.modulate = Color.from_hsv(0.5 + 0.5 * cos(time), 1.0, 1.0)
	$Particles2D.modulate = Color.from_hsv(0.5 + 0.5 * cos(time), 1.0, 1.0)
	time += delta / 2.0


func _on_ConfigurarButton_button_up():
	$MarginContainer/HBoxContainer/VBoxContainer/JogarButton.visible = false
	$MarginContainer/HBoxContainer/VBoxContainer/ConfigurarButton.visible = false
	$MarginContainer/HBoxContainer/VBoxContainer/SairButton.visible = false
	$MarginContainer/HBoxContainer/VBoxContainer/MusicaCheckButton.visible = true
	$MarginContainer/HBoxContainer/VBoxContainer/VoltarButton.visible = true


func _on_VoltarButton_button_up():
	$MarginContainer/HBoxContainer/VBoxContainer/JogarButton.visible = true
	$MarginContainer/HBoxContainer/VBoxContainer/ConfigurarButton.visible = true
	$MarginContainer/HBoxContainer/VBoxContainer/SairButton.visible = true
	$MarginContainer/HBoxContainer/VBoxContainer/MusicaCheckButton.visible = false
	$MarginContainer/HBoxContainer/VBoxContainer/VoltarButton.visible = false


func _on_MusicaCheckButton_toggled(button_pressed):
	MusicPlayer.play = $MarginContainer/HBoxContainer/VBoxContainer/MusicaCheckButton.pressed
	print(MusicPlayer.play)
	if $MarginContainer/HBoxContainer/VBoxContainer/MusicaCheckButton.pressed:
		MusicPlayer.play("MainTheme")
	else:
		MusicPlayer.stop_all()
