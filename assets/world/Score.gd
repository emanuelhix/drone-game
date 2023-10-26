extends Label
signal gameBeat;
var checkpointsLeft = 3;

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "x3 left"# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if checkpointsLeft == 0:
		gameBeat.emit()
	



func _on_crate_area_antidote_collected():
	checkpointsLeft -= 1
	text = "x %s left" % checkpointsLeft

