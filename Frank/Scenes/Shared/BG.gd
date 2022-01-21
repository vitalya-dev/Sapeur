extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _blurry = false


onready var start_position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var offset = position - get_viewport().get_mouse_position()
	position = lerp(position, position + offset, 0.1)
	position.x = clamp(position.x, start_position.x - 5, start_position.x + 5)
	position.y = clamp(position.y, start_position.y - 5, start_position.y + 5)

func show_explosion():
	play("explosion")

func show_glory():
	play("glory")

func show_default(id):
	play("default")
	frame = id

func show_rage():
	play("rage")

func show_credits():
	play("credits")

func blurry(value=true):
	_blurry = value
	if _blurry:
		#set_material(preload("res://Assets/Materials/blurry.material"))
		while _blurry:
			material.set_shader_param("time", material.get_shader_param("time") + 0.001)
			yield(get_tree(), "idle_frame")
	else:
		set_material(null)



