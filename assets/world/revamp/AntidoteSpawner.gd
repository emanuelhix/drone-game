extends Sprite2D

@export var pick_up_area : Area2D = null  # the area that the drone uses to pick things up
@onready var antidote_scene = preload("res://assets/antidote/antidote.tscn")
@onready var spawn_position_marker = find_child("SpawnPosition")
var last_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pick_up_area.item_picked_up.connect(on_item_picked_up)
	spawn_antidote()

func spawn_antidote():
	last_item = antidote_scene.instantiate()
	self.get_parent().call_deferred("add_child", last_item)
	last_item.set_deferred("freeze", true)
	last_item.global_position = self.global_position
	var tween = get_tree().create_tween()
	tween.tween_property(last_item, "global_position", spawn_position_marker.global_position, 1)
	
func on_item_picked_up(item):
	if item == last_item:
		spawn_antidote()
