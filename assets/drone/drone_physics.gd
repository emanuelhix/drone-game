extends RigidBody2D
@export var is_input_reversed : bool = true # if true, the right trigger will make the drone move right
@export var carried_antidote : RigidBody2D = null
@onready var carry_position_marker : Marker2D = find_child("CarryPosition")
var vertical_force = 125
var left_side = self.position
var right_side = self.position

func _ready():
	if carried_antidote != null:
		pick_up_item(carried_antidote)
	left_side.x-=12
	right_side.x+=12

func _input(event):
	if event.is_action_pressed("drop_item") and carried_antidote != null:
		on_drop_item(carried_antidote)

func _physics_process(delta):
	apply_fan_forces(delta)

func _integrate_forces(state):
	on_integrate_forces(state)

func apply_fan_forces(delta : float):
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
	if relative_force_location == Vector2.ZERO:
		rotation = 0

func on_integrate_forces(state):
	var rotation_radians = deg_to_rad(rotation_degrees)
	var new_rotation = clamp(rotation_radians, -PI/3, PI/3)
	var new_transform = Transform2D(new_rotation, self.position)
	self.transform = new_transform
	if self.rotation <= -9*PI/30 and self.angular_velocity < 0:
		self.angular_velocity = 2;
	elif self.rotation >= 9*PI/30 and self.angular_velocity > 0:
		self.angular_velocity = -2;

func on_drop_item(item : PhysicsBody2D):
	item.reparent(self.get_parent())
	item.set_deferred("freeze", false)

func pick_up_item(item : PhysicsBody2D):
	carried_antidote.reparent(self)
	carried_antidote.position = carry_position_marker.position
	carried_antidote.set_deferred("freeze", true)
