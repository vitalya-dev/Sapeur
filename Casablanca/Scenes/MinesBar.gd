extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_mines(count):
	for i in range(count):
		add_mine()

func add_mine():
	var mine = preload('res://Scenes/Mine.tscn').instance()
	add_child(mine) 

func sub_mine():
	if get_child_count() > 0:
		get_child(0).queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
