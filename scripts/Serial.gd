extends Node

const serial_res = preload("res://bin/gdserial.gdns")
var serial_port = serial_res.new()
var text = ""

signal A_pressed
signal B_pressed
signal Start_pressed
signal analogX_neutral
signal analog_left
signal analog_right
signal analogY_neutral
signal analog_up
signal analog_down


func _ready():
	for i in range(0, 20):
		if serial_port.open_port("COM" + str(i), 115200):
			print(i)
			break
	

func _process(_delta):
	var message = serial_port.read_text()
	for i in message:
		if i != "\n":
			for j in get_children():
				if i == j.get_name():
					j.text = i
		
		if i == "0":
			emit_signal("A_pressed")
		elif i == "1":
			emit_signal("B_pressed")
		elif i == "2":
			emit_signal("Start_pressed")
		elif i == "3":
			emit_signal("analogX_neutral")
		elif i == "4":
			emit_signal("analog_left")
		elif i == "5":
			emit_signal("analog_right")
		elif i == "6":
			emit_signal("analog_up")
		elif i == "7":
			emit_signal("analog_down")
		elif i == "9":
			emit_signal("analogY_neutral")
