extends HBoxContainer


func _ready():
	pass # Replace with function body.

func fill(count):
	for i in range(count):
		var mine = preload('res://Scenes/Mine.tscn').instance()
		add_child(mine)

func pop():
	if get_child_count() > 0:
		get_child(0).queue_free()		
		
