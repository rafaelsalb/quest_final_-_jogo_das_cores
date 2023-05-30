extends Node


var play = true

func play(title):
	if title == "MainTheme" and play:
		$MainTheme.play()
		$Boss.stop()
	elif title == "Boss" and play:
		$MainTheme.stop()
		$Boss.play()

func stop_all():
	$MainTheme.stop()
	$Boss.stop()
