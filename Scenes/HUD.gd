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
	if $Flags.get_child_count() > 0:
		$Flags.get_child(0).queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
