extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var value = 0 setget value_set, value_get
var _score = value

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(value)

func value_set(val):
	value = val

func value_get():
	return value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _score != value:
		_score += sign(value - _score)
		if !$Sound.playing:
			$Sound.play()
		text = str(_score)
