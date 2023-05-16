extends CanvasLayer


func _ready():
	$Control/CurrLevelLabel.text = "Nivel " + str(Global.curr_level)


func switch_pause():
	$Control/PauseMenu.visible = not $Control/PauseMenu.visible


func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause"):
		switch_pause()


func _on_ResumeButton_button_down():
	Global.switch_pause()
	switch_pause()


func _on_MenuButton_button_down():
	Global.change_level(0)
