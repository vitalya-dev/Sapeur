extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var voices : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func talk():
	stop()
	set_stream(voices[randi() % voices.size()])
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
