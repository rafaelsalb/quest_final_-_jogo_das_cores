extends Node


const LEVELS = ["Level1.tscn", "Level2.tscn"]


var checkpoint_pos: Vector2 = Vector2.ZERO
var checkpoint_checked: bool = false
var curr_color: int = PColors.WHITE
var curr_level: int = 0
var debug: bool = false
var lights_on: bool = false
var lives: int = 3
var is_player_in_dark_area


signal switch_debug_mode
signal lights_off
signal lights_on


func _unhandled_input(event):
	if Input.is_action_just_pressed("debug"):
		debug = not debug
		emit_signal("switch_debug_mode")
	if Input.is_action_just_pressed("switch_light"): #and is_player_in_dark_area:
		lights_on = not lights_on
		if lights_on:
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
		curr_color = PColors.WHITE
		checkpoint_checked = false
		checkpoint_pos = Vector2.ZERO
		go_to_main_menu()
	else:
		curr_color = PColors.WHITE
		get_tree().change_scene("res://scenes/" + LEVELS[curr_level])


func switch_pause():
	get_tree().paused = not get_tree().paused


func go_to_main_menu():
	get_tree().paused = false
	get_parent().get_tree().change_scene("res://scenes/MainMenu.tscn")


func checkpoint_checked(pos):
	checkpoint_checked = true
	checkpoint_pos = pos


func set_is_player_in_dark_area(x: bool):
	is_player_in_dark_area = x
	if not x:
		emit_signal("lights_on")
