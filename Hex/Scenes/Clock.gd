extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var think_time = 0
var time = 0

signal tick(time)

# Called when the node enters the scene tree for the first time.
func _ready():
	time = think_time
	########################################################################################
	$Timer.connect("timeout", self, "_on_timer_timeout")
	$Timer.start(1)
	########################################################################################
	adapt()

func _on_timer_timeout():
	time -= 1
	if time <= 0:
		$Timer.stop()
	emit_signal("tick", time)
	adapt()

func reset():
	time = think_time
	adapt()

func stop():
	time = think_time
	$Timer.stop()
	adapt()

func start():
	time = think_time
	$Timer.start(1)
	adapt()

func adapt():
	$Time.text = str(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
