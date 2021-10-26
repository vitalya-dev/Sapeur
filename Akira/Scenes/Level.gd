extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_field()
	_show_tutorial_message(0)


func connect_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_demine", self, "_on_tile_demine")


func _on_tile_open(tile):
	$OpenSFX.stop()
	$OpenSFX.play()


func _on_tile_demine(tile):
	$DemineSFX.stop()
	$DemineSFX.play()

func _show_tutorial_message(step):
	var message = preload('res://Scenes/Message.tscn').instance()
	message.messages = ["@Добро пожаловать в симуляцию сержант."]
	message.avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message.avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	add_child(message, true);
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
