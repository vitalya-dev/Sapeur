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
	$HexField.connect("tile_flagged", self, "_on_tile_flagged")
	$HexField.connect("tile_unflagged", self, "_on_tile_unflagged") 

func _on_tile_open(tile):
	if tile.mine:
		pass
		# $Music.stop()
		# $FireSFX.play()
		# $Field.state = "FAIL"
		# $BG.texture = preload("res://Assets/explosion.png")
		# yield(get_tree().create_timer(2), "timeout")
		# show_fail_message()
		# wait_for_message()
		# reload()
	else:
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
				
func _on_tile_flagged(tile):
	# $HUD.pop_flag()
	if $HexField.flags == 1:
		$LastFlagSFX.play()
		$Voice.talk()
	else:
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

func _on_tile_unflagged(tile):
	# $HUD.push_flag()
	$FlagSFX.play()
	$Voice.talk() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
