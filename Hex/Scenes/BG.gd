extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var start_position = position


func _process(delta):
	var offset = position - get_viewport().get_mouse_position()
	position = lerp(position, position + offset, 0.1)
	position.x = clamp(position.x, start_position.x - 5, start_position.x + 5)
	position.y = clamp(position.y, start_position.y - 5, start_position.y + 5)

