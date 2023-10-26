extends Node2D

#FIXME: INSANE DEPENDENCY
@onready var score_tracker = $UILayer/GameUI/ScoreLabel
@onready var fade_screen = $BlackFadeLayer
@onready var timer = $GameTimer

func _input(event):
	# built-in game reset
	if event.is_action_pressed("reset_game"):
		get_tree().reload_current_scene()

func _ready():
	score_tracker.game_completed.connect(on_all_antidotes_collected)
	timer.timeout.connect(on_game_timer_ended)
	
func on_all_antidotes_collected():
	fade_screen.fade_to_black(true)

func on_game_timer_ended():
	fade_screen.fade_to_black(false) 
	score_tracker.game_completed.disconnect(on_all_antidotes_collected)
