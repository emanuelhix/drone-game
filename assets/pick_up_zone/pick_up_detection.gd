extends Area2D

@onready var bezier_class = preload("res://assets/globals/bezier.gd").new()
@onready var drone : RigidBody2D = get_parent()
@onready var carry_position_marker : Marker2D = drone.find_child("CarryPosition")

signal item_picked_up(item : RigidBody2D)

var t : float = 0
var start : Vector2
var middle : Vector2
var end : Vector2
var colliding_body : RigidBody2D = null

func _ready():
	self.set_process(false)
	self.end = carry_position_marker.global_position

func _process(delta):
	# we must constantly update the end position because the drone is moving.
	self.end = carry_position_marker.global_position
	if t <= 1 and colliding_body != null:
		var curve_position : Vector2 = bezier_class.quadratic_bezier(start, middle, end, t)
		colliding_body.position = curve_position
		t += delta/0.3
	else:
		t = 0
		colliding_body.top_level = false
		colliding_body.reparent(self.get_parent())
		colliding_body.rotation = 0
		colliding_body.global_position = carry_position_marker.global_position
		item_picked_up.emit(colliding_body)
		set_process(false)

func trigger_pickup():
	if colliding_body != null:
		return
	var overlapping_bodies = self.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is Antidote and !body.is_collected and !body.is_dropped:
			self.colliding_body = body
			self.colliding_body.top_level = false
			self.start = body.global_position
			var size = self.find_child("CollisionShape2D").shape.size
			self.middle = self.global_position + Vector2(0, randf_range(-size.y/6, size.y/6))
			self.set_process(true)
