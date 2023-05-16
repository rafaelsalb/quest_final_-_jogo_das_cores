extends Light2D


func _ready():
	Global.connect("lights_off", self, "on_lights_off")
	Global.connect("lights_on", self, "on_lights_on")


func on_lights_off():
	enabled = false

func on_lights_on():
	enabled = true
