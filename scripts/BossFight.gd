extends Node2D


func _process(_delta) -> void:
	$Boss.aiming_at = Vector2(
		128 * -cos(atan2(
			$Player.position.x - $Boss.position.x,
			$Player.position.y - $Boss.position.y
		) + PI/2),
		128 * sin(atan2(
			$Player.position.x - $Boss.position.x,
			$Player.position.y - $Boss.position.y
		) + PI/2)
	)

	$Boss/Sprite.position = $Boss.aiming_at
	$Boss/Position2D.position = $Boss/Sprite.position
