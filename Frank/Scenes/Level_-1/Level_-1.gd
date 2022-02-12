extends "res://Scenes/Shared/BaseLevel.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	music = [preload("res://Assets/Sounds/Emotions [1213095934].mp3")]
	################################################################
	$New.connect("pressed", self, "emit_signal", ["complete"])
	$Exit.connect("pressed", get_node("/root/Game"), "quit_game")
	################################################################
	$Music.stream = music[0]
	$Music.play()
	$Music.fade_in()


func _esc_pressed():
	$Exit.emit_signal("pressed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
