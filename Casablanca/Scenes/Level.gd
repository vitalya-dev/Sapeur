extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	init_field()
	play_music()

func init_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_demine", self, "_on_tile_demine")

func play_music():
	$Music.play()


func _on_tile_open(tile):
	$OpenSFX.stop()
	$OpenSFX.play()
	$Voice.talk()
				
func _on_tile_demine(tile):
	$DemineSFX.stop()
	$DemineSFX.play()
	$Voice.talk()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
