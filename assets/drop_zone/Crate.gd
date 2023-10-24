extends Sprite2D

const LID_ANIM_NAME: String = "close_lid"
const LID_CLOSE_SPEED_SEC: float = 1
const IS_SHADER_ACTIVE_NAME: String = "is_active"
@export var flash_delay: float = 0.25
@export var animation_player: AnimationPlayer = null
@onready var invert_color : Shader = preload("res://assets/drop_zone/invert_color.gdshader")
@onready var lid_left : Sprite2D = self.get_parent().find_child("LidLeft")
@onready var lid_right : Sprite2D = self.get_parent().find_child("LidRight")
@onready var closed_lid_sprite : Sprite2D = self.get_parent().find_child("Closed")

func toggle_crate(open_lid: bool):
	animation_player.play(LID_ANIM_NAME, -1, LID_CLOSE_SPEED_SEC, open_lid)
	animation_player.animation_finished.connect(on_lid_closed)

func _ready():
	closed_lid_sprite.hide()
	toggle_crate(false)

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
		timer.queue_free()
	)
