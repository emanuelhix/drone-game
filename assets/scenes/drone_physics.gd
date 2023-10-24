extends RigidBody2D
var vertical_force = 50
var left_side = self.position
var right_side = self.position

# Called when the node enters the scene tree for the first time.
func _ready():
	left_side.x-=15
	right_side.x+=15


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("left_fan"):
		apply_force(self.global_transform.y*Input.get_action_strength("left_fan")*-vertical_force, left_side)
	if Input.is_action_pressed("right_fan"):
		apply_force(self.global_transform.y*Input.get_action_strength("right_fan")*-vertical_force, right_side)

func _integrate_forces(state):
	var rotation_radians = deg_to_rad(rotation_degrees)
	var new_rotation = clamp(rotation_radians, -PI/3, PI/3)
	var new_transform = Transform2D(new_rotation, self.position)
	self.transform = new_transform
	if self.rotation <= -9*PI/30 and self.angular_velocity < 0:
		self.angular_velocity = 2;
	elif self.rotation >= 9*PI/30 and self.angular_velocity > 0:
		self.angular_velocity = -2;
