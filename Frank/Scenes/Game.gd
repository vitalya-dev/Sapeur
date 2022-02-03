extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_current_level()

func _on_level_complete():
	current_level += 1
	$Level.queue_free()
	_load_current_level()

func _load_current_level():
	var level = load('res://Scenes/Level_%d/Level_%d.tscn' % [current_level, current_level]).instance()
	level.connect("complete", self, "_on_level_complete")
	add_child(level, true);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
