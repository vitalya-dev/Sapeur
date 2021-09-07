extends CanvasLayer


# Declare member variables here. Examples:
export var flags_count : int
var flags : Array
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(flags_count):
		push_flag()
		

func push_flag():
	var flag = preload('res://Scenes/Flag.tscn').instance()
	$Flags.add_child(flag)

func pop_flag():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
