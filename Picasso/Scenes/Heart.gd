extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum States {IDLE, BEATING, DYING, DEAD}

var state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animation.connect("animation_finished", self, "_on_animation_finished")
	_change_state(States.IDLE)

func _change_state(new_state):
	match new_state:
		States.IDLE:
			$Animation.play("idle")
		States.BEATING:
			$Animation.stop()
			$Animation.play("beating")
		States.DYING:
			$Animation.play("dying")
		States.DEAD:
			$Animation.play("dead")
	state = new_state

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.pressed:
			match state:
				States.IDLE, States.BEATING, States.DYING:
					_change_state(States.BEATING)

func _on_animation_finished(_name):
	match state:
		States.IDLE:
			pass
		States.BEATING:
			_change_state(States.DYING)
		States.DYING:
			_change_state(States.DEAD)
		States.DEAD:
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	$Label.text = str(state)
