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
	self.body_entered.connect(on_body_entered)
	self.set_process(false)
	self.end = end_marker.global_position

func _process(delta):
	# curve path
	if t <= 1 and colliding_body != null:
		var curve_position : Vector2 = bezier_class.quadratic_bezier(start, middle, end, t)
		colliding_body.position = curve_position
		t += delta/0.465
	else:
		colliding_body.rotation = 0
		antidote_collected.emit()
		# cleanup
		set_process(false)
		self.body_entered.disconnect(on_body_entered)

func on_body_entered(body : Antidote):
	self.colliding_body = body
	body.freeze_mode = body.FREEZE_MODE_STATIC
	body.set_deferred("freeze", true)
	body.top_level = true
	self.start = body.global_position
	colliding_body.global_position = self.start
	var size = self.find_child("CollisionShape2D").shape.size
	self.middle = self.global_position + Vector2(0, randf_range(-size.y/6, size.y/6))
	self.set_process(true)
