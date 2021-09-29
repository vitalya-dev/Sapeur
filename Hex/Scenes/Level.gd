extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = "GAME"


# Called when the node enters the scene tree for the first time.
func _ready():
	init_field() 
	play_music()


func play_music():
	$Music.play()

func init_field():
	$HexField.connect("tile_open", self, "_on_tile_open")
	$HexField.connect("tile_demine", self, "_on_tile_demine")

func fail():
	$Music.stop()
	$FireSFX.play() 
	$BG.texture = preload("res://Assets/Graphics/explosion.png") 
	mouse_filter = Control.MOUSE_FILTER_STOP
	yield(get_tree().create_timer(1), "timeout")
	state = "FAIL"

func _on_tile_open(tile):
	if tile.is_mined():
		fail()
	else:
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
				
func _on_tile_demine(tile):
	if not tile.is_mined():
		fail()
	else:
		$FlagSFX.stop()
		$FlagSFX.play()
		$Voice.talk()

func _input(ev):
	match state:
		"GAME":
			pass
		"FAIL":
			if ev is InputEventMouseButton and (ev.button_index == 1 or ev.button_inde == 2) and ev.pressed:
				get_tree().reload_current_scene()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
