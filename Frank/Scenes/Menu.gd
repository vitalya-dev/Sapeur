extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal button_pressed(button_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Continue.connect("pressed", self, "emit_signal", ["button_pressed", "continue"])
	$Exit.connect("pressed", self, "emit_signal", ["button_pressed", "exit"])		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
