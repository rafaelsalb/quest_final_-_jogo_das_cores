extends Node


var debug: bool = false
var lights_on: bool = false

signal lights_off
signal lights_on


func _unhandled_input(event):
	if Input.is_action_just_pressed("debug"):
		debug = not debug
	if Input.is_action_just_pressed("switch_light"):
		lights_on = not lights_on
		if lights_on:
			emit_signal("lights_off")
		else:
			emit_signal("lights_on")
