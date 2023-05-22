extends Node


const LEVELS = ["Level1.tscn", "TestLevel2.tscn"]


var curr_color: int = PColors.WHITE
var curr_level: int = 1
var debug: bool = false
var lights_on: bool = false
var lives: int = 3


signal switch_debug_mode
signal lights_off
signal lights_on


func _unhandled_input(event):
	if Input.is_action_just_pressed("debug"):
		debug = not debug
		emit_signal("switch_debug_mode")
	if Input.is_action_just_pressed("switch_light"):
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
	get_tree().paused = not get_tree().paused


func go_to_main_menu():
	get_tree().paused = false
	get_parent().get_tree().change_scene("res://scenes/MainMenu.tscn")


func checkpoint_checked(pos):
	print(pos)
