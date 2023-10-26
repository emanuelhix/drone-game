extends Area2D

@onready var end_marker : Marker2D = find_child("End")
@onready var bezier_class = preload("res://assets/globals/bezier.gd").new()
signal antidote_collected

var t : float = 0
var start : Vector2
var middle : Vector2
var end : Vector2
var colliding_body : RigidBody2D = null

func _ready():
	self.set_process(false)
	self.end = end_marker.global_position

func _process(delta):
	# curve path
	end = end_marker.global_position
	if t <= 1 and colliding_body != null:
		var curve_position : Vector2 = bezier_class.quadratic_bezier(start, middle, end, t)
		colliding_body.position = curve_position
		t += delta/0.465
	else:
		self.get_parent().set_deferred("freeze", false)
		print(self.get_parent())
		colliding_body.reparent(self.get_parent())
		colliding_body.rotation = 0
		colliding_body.position = Vector2()
		# cleanup
		set_process(false)

func trigger_pickup():
	var overlapping_bodies = self.get_overlapping_bodies()
	for body in overlapping_bodies:
		if not body is Antidote:
			pass
		self.get_parent().set_deferred("freeze", true)
		self.colliding_body = body
		body.freeze_mode = body.FREEZE_MODE_STATIC
		body.set_deferred("freeze", true)
		body.top_level = true
		self.start = body.global_position
		#colliding_body.global_position = self.start
		var size = self.find_child("CollisionShape2D").shape.size
		self.middle = self.global_position + Vector2(0, randf_range(-size.y/6, size.y/6))
		self.set_process(true)

"""
func on_body_entered(body : RigidBody2D):
	if !(body is Antidote):
		return
	self.colliding_body = body
	body.freeze_mode = body.FREEZE_MODE_STATIC
	body.set_deferred("freeze", true)
	body.top_level = true
	self.start = body.global_position
	colliding_body.global_position = self.start
	var size = self.find_child("CollisionShape2D").shape.size
	self.middle = self.global_position + Vector2(0, randf_range(-size.y/6, size.y/6))
	self.set_process(true)
"""
