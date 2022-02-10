extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal complete()



var music_1 = preload("res://Assets/Sounds/Emotions [1213095934].mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	$New.connect("pressed", self, "emit_signal", ["complete"])
	$Exit.connect("pressed", get_node("/root/Game"), "quit_game")
	################################################################
	$Music.stream = music_1
	$Music.play()
	$Music.fade_in()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
