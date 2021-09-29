extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	init_field() 
	play_music()


func play_music():
	$Music.play()

func init_field():
	$HexField.connect("tile_open", self, "_on_tile_open")
	$HexField.connect("tile_demine", self, "_on_tile_demine")

func _on_tile_open(tile):
	if tile.is_mined():
		$Music.stop()
		$FireSFX.play() 
		$BG.texture = preload("res://Assets/Graphics/explosion.png") 
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
				
func _on_tile_demine(tile):
	$FlagSFX.stop()
	$FlagSFX.play()
	$Voice.talk()
	# if is_win():
	# 	$Music.stop()
	# 	$VictorySFX.play()
	# 	$Field.state = "WIN"
	# 	$BG.texture = preload("res://Assets/war_victory.png")
	# 	yield(get_tree().create_timer(1.5), "timeout")
	# 	show_win_message()

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.pressed:
			print("lmb clicked")
		if ev.button_index == 2 and ev.pressed:
			print("rmb clicked")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
