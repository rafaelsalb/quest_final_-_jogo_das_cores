extends Timer


func _ready():
	Global.connect("switch_debug_mode", self, "on_switch_debug_mode")


func _on_FPScounter_timeout():
	print(Engine.get_frames_per_second())


func on_switch_debug_mode():
	if is_stopped():
		start()
	else:
		stop()
