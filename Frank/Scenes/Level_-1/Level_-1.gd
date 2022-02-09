extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal complete()

# Called when the node enters the scene tree for the first time.
func _ready():
	$New.connect("pressed", self, "emit_signal", ["complete"])
	$Exit.connect("pressed", get_node("/root/Game"), "quit_game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
