extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal button_pressed(button_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Continue.connect("pressed", self, "emit_signal", ["button_pressed", "continue"])
	$Exit.connect("pressed", self, "emit_signal", ["button_pressed", "exit"])		

func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		emit_signal("button_pressed", "continue")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
