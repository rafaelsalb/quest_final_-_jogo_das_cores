extends Node


const LEVELS = ["Level1.tscn", "Level2.tscn"]


var curr_color: int = PColors.WHITE
var curr_level: int = 0
var debug: bool = false
var lights_on: bool = true
var lives: int = 3
var is_player_in_dark_area
var can_pause: bool = true


signal switch_debug_mode
signal lights_off
signal lights_on


func _ready():
	MusicPlayer.play("MainTheme")
	Serial.connect("B_pressed", self, "switch_light")


func _unhandled_input(event):
	if Input.is_action_just_pressed("debug"):
		debug = not debug
		emit_signal("switch_debug_mode")
	if Input.is_action_just_pressed("switch_light") and is_player_in_dark_area and $SwitchLightsCooldown.is_stopped():
		$SwitchLightsCooldown.start()
		lights_on = not lights_on
		if not lights_on:
			emit_signal("lights_off")
		else:
			emit_signal("lights_on")


func switch_light():
	if is_player_in_dark_area and $SwitchLightsCooldown.is_stopped():
		$SwitchLightsCooldown.start()
		lights_on = not lights_on
		if not lights_on:
			emit_signal("lights_off")
		else:
			emit_signal("lights_on")


func set_lights(x: bool):
	lights_on = not lights_on
	if lights_on:
		emit_signal("lights_off")
	else:
		emit_signal("lights_on")


func _input(_event):
	if Input.is_action_just_pressed("pause"):
		switch_pause()


func change_level(i: int):
	curr_color = PColors.WHITE
	get_tree().change_scene("res://scenes/" + LEVELS[i])
	curr_level = i


func check_game_over():
	if lives < 0:
		lives = 3
		go_to_main_menu()
		curr_color = PColors.WHITE
	else:
		curr_color = PColors.WHITE
		get_tree().change_scene("res://scenes/" + LEVELS[curr_level])


func switch_pause():
	if $PauseCooldown.is_stopped():
		get_tree().paused = not get_tree().paused
		$PauseCooldown.start()
		can_pause = false


func go_to_main_menu():
	get_tree().paused = false
	get_parent().get_tree().change_scene("res://scenes/MainMenu.tscn")


func checkpoint_checked(pos):
	print(pos)


func set_is_player_in_dark_area(x: bool):
	is_player_in_dark_area = x
	print(is_player_in_dark_area)
	if not x and not lights_on:
		lights_on = true
		print("set", is_player_in_dark_area)
		emit_signal("lights_on")


func _on_PauseCooldown_timeout():
	can_pause = true


func _on_BossDeathCooldown_timeout():
	pass # Replace with function body.
