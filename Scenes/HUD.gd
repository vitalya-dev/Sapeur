extends CanvasLayer


# Declare member variables here. Examples:
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		

func push_flag():
	var flag = preload('res://Scenes/Flag.tscn').instance()
	$Flags.add_child(flag)

func pop_flag():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
