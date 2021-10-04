extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = "GAME"


# Called when the node enters the scene tree for the first time.
func _ready():
	init_field() 
	init_hud()
	play_music()

func play_music():
	$Music.play()

func init_field():
	$HexField.connect("tile_open", self, "_on_tile_open")
	$HexField.connect("tile_demine", self, "_on_tile_demine")

func init_hud():
	$HUD/Clock.connect("tick", self, "_on_clock_tick")
	$HUD/MinesContainer.fill($HexField.mines)

func _on_tile_open(tile):
	if tile.mine:
		fail()
	else:
		$HUD/Clock.reset()
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
		
				
func _on_tile_demine(tile):
	if not tile.mine:
		fail()
	elif $HexField.no_more_closed_mines():
		$HexField.mines = $HexField.mines / 2
		if $HexField.mines > 0:
			new_round()
		else:
			victory()
	else:
		$HUD/Clock.reset()
		$FlagSFX.stop()
		$FlagSFX.play()
		$Voice.talk()
	$HUD/MinesContainer.pop()
	

func _on_clock_tick(time):
	match time:
		2:
			$TimeSFX.play()
		0:
			fail()

func fail():
	$HUD/Clock.stop()
	$Music.stop()
	$FireSFX.play() 
	$BG.texture = preload("res://Assets/Graphics/explosion.png") 
	mouse_filter = Control.MOUSE_FILTER_STOP
	yield(get_tree().create_timer(1), "timeout")
	state = "FAIL"

func victory():
	$HUD/Clock.stop()
	$Music.stop()
	$VictorySFX.play() 
	$BG.texture = preload("res://Assets/Graphics/war_victory.png") 
	mouse_filter = Control.MOUSE_FILTER_STOP
	yield(get_tree().create_timer(1), "timeout")
	state = "WIN"

func new_round():
	$HUD/Clock.stop()
	$VictorySFX.play()
	yield(get_tree().create_timer(1.5), "timeout")
	$HexField.reset_all_tiles_except_demined()
	$HexField.distribute_mines($HexField.mines)
	$HUD/MinesContainer.fill($HexField.mines)
	yield(get_tree().create_timer(0.5), "timeout")
	$HexField.open_one_empty_tile()
	$HUD/Clock.start()




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
