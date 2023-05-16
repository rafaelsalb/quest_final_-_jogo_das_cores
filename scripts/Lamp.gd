extends Light2D


func _ready():
	Global.connect("lights_off", self, "on_lights_off")
	Global.connect("lights_on", self, "on_lights_on")


func on_lights_off():
	enabled = false
	$CanvasModulate.color = Color(0, 0, 0)

func on_lights_on():
	enabled = true
	$CanvasModulate.color = Color(1, 1, 1)
