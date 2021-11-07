extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var initial_volume = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_volume = volume_db

func fade_out():
	$Tween.remove_all()
	$Tween.interpolate_property(self, "volume_db", volume_db, initial_volume - 20, 5)
	$Tween.start()

func fade_in():
	$Tween.remove_all()
	$Tween.interpolate_property(self, "volume_db", volume_db, initial_volume + 20, 5)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
