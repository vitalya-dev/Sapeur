extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func stamped(mark):
	match mark:
		"A":
			frame = 0
		"B":
			frame = 1
		"C":
			frame = 2
		"E":
			frame = 3
		"F":
			frame = 4
	$Stamp.play()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
