extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = "GAME"

signal _complete

# Called when the node enters the scene tree for the first time.
func _ready():
	disable_mouse_propagate()
	init_field()
	init_bg()
	fill_mines_bar()
	yield(self, "_complete")
	play_music()
	enable_mouse_propagate()

func disable_mouse_propagate():
	mouse_filter = Control.MOUSE_FILTER_STOP

func enable_mouse_propagate():
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func init_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_demine", self, "_on_tile_demine")

func init_bg():
	$BG.show_normal()

func fill_mines_bar():
	for i in range($Field.mines):
		$HUD/MinesBar.add_mine()
		yield(get_tree().create_timer(0.1), "timeout")
		$DemineSFX.play()
	emit_signal("_complete")

func play_music():
	$Music.play()

func _on_tile_open(tile):
	if tile.mine:
		fail()
	else:
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
				
func _on_tile_demine(tile):
	if not tile.mine:
		fail() 
	elif $Field.is_demined():
		$Field.mines = $Field.mines / 2 
		if $Field.mines > 0:
			new_round()
		else:
			victory() 
	else:
		$DemineSFX.stop()
		$DemineSFX.play()
		$Voice.talk()
	$HUD/MinesBar.sub_mine()			

func fail():
	$Music.stop()
	$FireSFX.play()  
	$BG.show_explosion()
	disable_mouse_propagate()
	yield(get_tree().create_timer(1), "timeout")
	state = "FAIL"

func victory():
	$Music.stop()
	$VictorySFX.play()
	$BG.show_glory()
	disable_mouse_propagate()
	yield(get_tree().create_timer(1), "timeout")
	state = "WIN"

func new_round():
	disable_mouse_propagate()
	#######################################################
	$VictorySFX.play()
	yield(get_tree().create_timer(1.5), "timeout")
	$Field.close_empty_tiles()
	$Field.distribute_mines($Field.mines)
	#######################################################
	fill_mines_bar()
	yield(self, "_complete")
	#######################################################
	yield(get_tree().create_timer(1), "timeout")
	$Field.open_empty_tile()
	#######################################################
	enable_mouse_propagate()
	


func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()
	match state:
		"GAME":
			pass
		"FAIL", "WIN":
			if ev is InputEventMouseButton and ev.pressed and (ev.button_index == 1 or ev.button_index == 2):
				get_tree().reload_current_scene() 

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
