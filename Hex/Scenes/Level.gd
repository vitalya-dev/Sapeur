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

func _on_tile_open(tile):
	if tile.is_mined():
		fail()
	elif no_more_normal_tiles():
		new_round()
	else:
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
				
func _on_tile_demine(tile):
	if not tile.is_mined():
		fail()
	elif no_more_normal_tiles():
		new_round()
	else:
		$FlagSFX.stop()
		$FlagSFX.play()
		$Voice.talk()

func no_more_normal_tiles():
	return len(get_tree().get_nodes_in_group("normal_tiles")) == 0

func fail():
	$Music.stop()
	$FireSFX.play() 
	$BG.texture = preload("res://Assets/Graphics/explosion.png") 
	mouse_filter = Control.MOUSE_FILTER_STOP
	yield(get_tree().create_timer(1), "timeout")
	state = "FAIL"

func victory():
	$Music.stop()
	$VictorySFX.play() 
	$BG.texture = preload("res://Assets/Graphics/war_victory.png") 
	mouse_filter = Control.MOUSE_FILTER_STOP
	yield(get_tree().create_timer(1), "timeout")
	state = "WIN"

func new_round():
	$VictorySFX.play()
	yield(get_tree().create_timer(1.5), "timeout")
	for tile in get_tree().get_nodes_in_group("open_tiles"):
		tile.close()
	$HexField.distribute_mines($HexField.mines)

func _input(ev):
	match state:
		"GAME":
			pass
		"FAIL", "WIN":
			if ev is InputEventMouseButton and ev.pressed and (ev.button_index == 1 or ev.button_index == 2):
				get_tree().reload_current_scene()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
