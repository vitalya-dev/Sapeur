extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_hover = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("mouse_entered", self, "on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "on_mouse_exited")


func on_mouse_entered():
	is_hover = true

func on_mouse_exited():
	is_hover = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
