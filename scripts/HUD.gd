extends CanvasLayer


func _ready():
	$Control/CurrLevelLabel.text = "Nivel " + str(Global.curr_level + 1)
	$Control/PauseMenu/MusicaCheckButton.pressed = MusicPlayer.play


func switch_pause():
	$Control/PauseMenu.visible = not $Control/PauseMenu.visible


func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause"):
		switch_pause()


func _on_ResumeButton_button_down():
	Global.switch_pause()
	switch_pause()


func _on_MenuButton_button_down():
	Global.go_to_main_menu()


func _on_SettingsButton_button_up():
	$Control/PauseMenu/ResumeButton.visible = false
	$Control/PauseMenu/SettingsButton.visible = false
	$Control/PauseMenu/MenuButton.visible = false
	$Control/PauseMenu/MusicaCheckButton.visible = true
	$Control/PauseMenu/VoltarButton.visible = true


func _on_MusicaCheckButton_pressed():
	MusicPlayer.play = $Control/PauseMenu/MusicaCheckButton.pressed
	print(MusicPlayer.play)
	if $Control/PauseMenu/MusicaCheckButton.pressed:
		MusicPlayer.play("MainTheme")
	else:
		MusicPlayer.stop_all()


func _on_VoltarButton_button_up():
	$Control/PauseMenu/ResumeButton.visible = true
	$Control/PauseMenu/SettingsButton.visible = true
	$Control/PauseMenu/MenuButton.visible = true
	$Control/PauseMenu/MusicaCheckButton.visible = false
	$Control/PauseMenu/VoltarButton.visible = false
