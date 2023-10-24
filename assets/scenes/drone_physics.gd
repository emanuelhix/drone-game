extends RigidBody2D
var vertical_force = 200
var horizontal_force = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("fly_up"):
		apply_central_force(Vector2(0,-vertical_force*Input.get_action_strength("fly_up")))
	if Input.is_action_pressed("fly_right") or Input.is_action_pressed("fly_left"):
		apply_central_force(Vector2(horizontal_force*Input.get_axis("fly_left", "fly_right"), 0))
