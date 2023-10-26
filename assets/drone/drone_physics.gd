extends RigidBody2D
@export var is_input_reversed : bool = true # if true, the right trigger will make the drone move right
@export var carried_antidote : RigidBody2D = null
@export var pick_up_area : Area2D = null
@onready var carry_position_marker : Marker2D = find_child("CarryPosition")
var vertical_force = 125
var left_side = self.position
var right_side = self.position

func _ready():
	# if an antidote is parented to this object before hand, start the drone off carrying it.
	if carried_antidote != null:
		carried_antidote.reparent(self)
		carried_antidote.position = carry_position_marker.position
		carried_antidote.set_deferred("freeze", true)
	left_side.x-=12
	right_side.x+=12
	if pick_up_area != null:
		pick_up_area.item_picked_up.connect(on_item_picked_up)

func _input(event):
	if event.is_action_pressed("drop_item") and carried_antidote != null:
		on_drop_item()
	elif event.is_action_pressed("pick_up_item") and carried_antidote == null and pick_up_area != null:
		on_pick_up_item()

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
	if(Input.get_action_strength("left_fan") > 0 and Input.get_action_strength("right_fan") > 0):
		apply_force(Vector2(0,-1)*vertical_force, left_side)
		apply_force(Vector2(0,-1)*vertical_force, right_side)
		if self.rotation<0:
			self.angular_velocity=3
		elif self.rotation>0:
			self.angular_velocity=-3
	elif(Input.get_action_strength("left_fan") > 0 or Input.get_action_strength("right_fan") > 0):
		apply_force( (self.global_transform.y * -vertical_force) * fan_strength, relative_force_location)
	else:
		if self.rotation<0:
			self.angular_velocity=1.5*PI
		elif self.rotation>0:
			self.angular_velocity=-1.5*PI

func on_integrate_forces(state):
	var rotation_radians = deg_to_rad(rotation_degrees)
	var new_rotation = clamp(rotation_radians, -PI/3, PI/3)
	var new_transform = Transform2D(new_rotation, self.position)
	self.transform = new_transform
	if self.rotation <= -9*PI/30 and self.angular_velocity < 0:
		self.angular_velocity = 2
	elif self.rotation >= 9*PI/30 and self.angular_velocity > 0:
		self.angular_velocity = -2

func on_drop_item():
	carried_antidote.top_level = true
	carried_antidote.global_position = carry_position_marker.global_position
	carried_antidote.set_deferred("freeze", false)
	carried_antidote = null
	if pick_up_area != null:
		pick_up_area.colliding_body = null

func on_pick_up_item():
	pick_up_area.trigger_pickup()

func on_item_picked_up(item : RigidBody2D):
	self.carried_antidote = item
