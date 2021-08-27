extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var flagged = false setget _set_flagged
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(ev):
	if is_hovered() and ev is InputEventMouseButton:
		if ev.button_index == 2 and ev.pressed:
			set('flagged', !flagged)
			
			
func _set_flagged(value):
	flagged = value
	if flagged:
		set_text("F")
	else:
		set_text("")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(flagged)
