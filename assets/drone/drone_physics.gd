extends RigidBody2D
@export var is_input_reversed : bool = true # if true, the right trigger will make the drone move right
var vertical_force = 125
var left_side = self.position
var right_side = self.position

func _ready():
	left_side.x-=12
	right_side.x+=12

func _physics_process(delta):
	# if both trigger buttons are held, go straight up.
	# otherwise, move towards that direction.
	var relative_force_location = Vector2.ZERO
	if Input.is_action_pressed("left_fan") and !Input.is_action_pressed("right_fan"):
		relative_force_location = left_side if !is_input_reversed else right_side
	elif Input.is_action_pressed("right_fan") and !Input.is_action_pressed("left_fan"):
		relative_force_location = right_side if !is_input_reversed else left_side
	# if no trigger buttons are held, fan strength is zero, which causes no upwards force to be applied on this frame. 
	# thus, the drone falls with gravity.
	var fan_strength : int = clamp(Input.get_action_strength("left_fan") + Input.get_action_strength("right_fan"), 0, 1)
	apply_force( (self.global_transform.y * -vertical_force) * fan_strength, relative_force_location)
	if relative_force_location == Vector2.ZERO and rotation != 0:
		rotation = 0
		
func _integrate_forces(state):
	var rotation_radians = deg_to_rad(rotation_degrees)
	var new_rotation = clamp(rotation_radians, -PI/3, PI/3)
	var new_transform = Transform2D(new_rotation, self.position)
	self.transform = new_transform
	if self.rotation <= -9*PI/30 and self.angular_velocity < 0:
		self.angular_velocity = 2;
	elif self.rotation >= 9*PI/30 and self.angular_velocity > 0:
		self.angular_velocity = -2;
