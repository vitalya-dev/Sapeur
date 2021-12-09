extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_animate()


# func _input(ev):
# 	if ev is InputEventMouseButton:
# 		if ev.button_index == 1 and ev.pressed:
# 			$Tween.remove_all()
# 			_animate()

func _animate():
	rect_size.x = 0
	modulate = Color.white
	#============================================================#
	$Tween.interpolate_property(self, "rect_size", rect_size, rect_size + Vector2(92, 0), 0.5)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	#============================================================#
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, 0.5)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	#============================================================#
	queue_free()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
