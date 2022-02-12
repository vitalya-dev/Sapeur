extends "res://Scenes/Shared/BaseLevel.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	music = [preload("res://Assets/Sounds/Emotions [1213095934].mp3")]
	################################################################
	$New.connect("pressed", self, "emit_signal", ["complete"])
	$Exit.connect("pressed", get_node("/root/Game"), "quit_game")
	################################################################
	_start_level()


func _start_level():
	yield(get_tree(), "idle_frame")
	_mission(0)

func _mission(part):
	if is_queued_for_deletion():
		return
	match part:
		0:
			$Music.stream = music[0]
			$Music.play()
			$Music.fade_in()
			_mission(part+1)
			return
		1:
			yield()
			_mission(part+1)
			return
		_:
			emit_signal("complete") 
			return

func _esc_pressed():
	$Exit.emit_signal("pressed")
