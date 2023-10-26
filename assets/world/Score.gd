extends Label

@export var drop_zone_0 : Area2D = null
@export var drop_zone_1 : Area2D = null
@onready var game_manager = self.get_parent()
@onready var drop_zones = [drop_zone_0, drop_zone_1]
@onready var deliveriesLeft : int = drop_zones.size()

signal game_completed();

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Deliveries Remaining: " + str(deliveriesLeft)
	for zone in drop_zones:
		zone.antidote_collected.connect(on_crate_area_antidote_collected)

func on_crate_area_antidote_collected():
	deliveriesLeft -= 1
	text = "Deliveries Remaining: " + str(deliveriesLeft)
	if deliveriesLeft <= 0:
		game_completed.emit()
