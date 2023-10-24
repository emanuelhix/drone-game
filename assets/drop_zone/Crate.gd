extends Sprite2D

const LID_ANIM_NAME: String = "close_lid"
const LID_CLOSE_SPEED_SEC: float = 1
const IS_SHADER_ACTIVE_NAME: String = "is_active"
@export var lid_open : bool = false # whether or not the lid is open or closed
@export var toggle_on_ready : bool = true # will set the crate to be open or closed on ready
@export var flash_delay: float = 0.25
@export var animation_player: AnimationPlayer = null
@onready var invert_color : Shader = preload("res://assets/drop_zone/invert_color.gdshader")
@onready var lid_left : Sprite2D = self.get_parent().find_child("LidLeft")
@onready var lid_right : Sprite2D = self.get_parent().find_child("LidRight")
@onready var closed_lid_sprite : Sprite2D = self.get_parent().find_child("Closed")
@onready var crate_detection : Area2D = self.get_parent().get_parent()

func toggle_crate(open_lid: bool):
	if open_lid:
		animation_player.play_backwards(LID_ANIM_NAME)
	else:
		animation_player.play(LID_ANIM_NAME, -1, LID_CLOSE_SPEED_SEC, open_lid)
		animation_player.animation_finished.connect(on_lid_closed)

func _ready():
	crate_detection.antidote_collected.connect(on_antidote_collected)
	closed_lid_sprite.hide()
	if toggle_on_ready:
		toggle_crate(lid_open)

# handles the flash animation
func on_lid_closed(_anim_name):
	lid_left.hide()
	lid_right.hide()
	closed_lid_sprite.show()
	closed_lid_sprite.material.set_shader_parameter(IS_SHADER_ACTIVE_NAME, true)
	var timer : Timer = Timer.new()
	self.add_child(timer)
	timer.start(flash_delay)	
	timer.timeout.connect(func(): 
		closed_lid_sprite.material.set_shader_parameter(IS_SHADER_ACTIVE_NAME, false)
		animation_player.animation_finished.disconnect(on_lid_closed)
		timer.queue_free()
	)

func on_antidote_collected():
	toggle_crate(false)
