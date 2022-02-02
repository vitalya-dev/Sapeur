extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = load('res://Scenes/Level_0/Level_%d.tscn' % current_level).instance()
	add_child(level, true);


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
