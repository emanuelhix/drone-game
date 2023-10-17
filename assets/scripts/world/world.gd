extends Node2D

func _input(event):
	# built-in game reset
	if event.is_action_pressed("reset_game"):
		get_tree().reload_current_scene()
