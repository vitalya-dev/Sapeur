extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = "GAME"


# Called when the node enters the scene tree for the first time.
func _ready():
	init_field()
	init_bg()
	play_music()

func init_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_demine", self, "_on_tile_demine")

func init_bg():
	$BG.play("Normal")

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
	$DemineSFX.stop()
	$DemineSFX.play()
	$Voice.talk()

func fail():
	$Music.stop()
	$FireSFX.play()  
	$BG.play("Explosion")
	mouse_filter = Control.MOUSE_FILTER_STOP
	yield(get_tree().create_timer(1), "timeout")
	state = "FAIL"




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
