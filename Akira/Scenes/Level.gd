extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_field() 


func connect_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_demine", self, "_on_tile_demine")


func _on_tile_open(tile):
	$OpenSFX.stop()
	$OpenSFX.play()


func _on_tile_demine(tile):
	$DemineSFX.stop()
	$DemineSFX.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
