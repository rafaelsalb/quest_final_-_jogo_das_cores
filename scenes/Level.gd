extends Node2D


var boss_fight_active: bool = false
var is_boss_alive: bool = true
var color_changer = preload("res://scenes/BossFightColorChanger.tscn")


func _ready():
	$Boss.connect("damaged", self, "place_color_changers")


func _process(_delta):
	if is_boss_alive:
		$Boss.aim_at($Player.position)
	else:
		if not $Panel2.visible:
			$Panel2.visible = true
			$Panel2/Label.visible = true


func _on_BossFightArea_body_exited(body):
	boss_fight_active = true
	$Boss.active = true
	$Boss.set_physics_process(true)
	$Boss.set_process(true)
	$BossFight/Timer.start()
	$ColorGate6.set_collision_layer_bit(8, true)
	$ColorGate6.set_collision_mask_bit(8, true)
	$BossFightArea.set_deferred("monitoring", false)
	$BossFightWall.visible = true
	for i in range(9):
		$BossFightWall.set_collision_layer_bit(i, true)
		$BossFightWall.set_collision_mask_bit(i, true)
	MusicPlayer.play("Boss")


func place_color_changers():
	$BossFight/Timer.start()


func _on_Timer_timeout():
	var color_changer_instance = color_changer.instance()
	color_changer_instance.global_position = $BossFight.position + $BossFight.get_children()[randi() % 9].position
	color_changer_instance.CONSUMABLE = true
	color_changer_instance.color_name = PColors.Color_TO_NAME[$Boss.possible_colors[0]]
	add_child(color_changer_instance)
