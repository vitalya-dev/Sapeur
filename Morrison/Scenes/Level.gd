extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$Music.play()
	_start_tutorial(0)

func _start_tutorial(part):
	$BG.show_default()
	match part:
		0:
			$Music.fade_out()
			_prepare_field(5)
			$Music.fade_in()
			if (yield(_solve(part), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)

func _play_sfx(event, part):
	if event["owner"] == "field" and event["name"] == "tile_open":
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
	elif event["owner"] == "field" and (event["name"] == "tile_flag" or event["name"] == "tile_unflag"):
		$FlagSFX.stop()
		$FlagSFX.play()
		$Voice.talk()

func _play_gfx(event, part):
	pass

		
func _message_window(messages):
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_colonel.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	message_window.get_node("Message").avatar_3 = preload("res://Assets/Graphics/Avatars/avatar_operator.png")
	message_window.get_node("Message").avatar_4 = preload("res://Assets/Graphics/Avatars/avatar_mom.png")
	message_window.get_node("Message").avatar_5 = preload("res://Assets/Graphics/Avatars/avatar_bomber.png")
	message_window.get_node("Message").avatar_6 = preload("res://Assets/Graphics/Avatars/avatar_brother.png")
	message_window.get_node("Message").avatar_7 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	add_child(message_window, true);
	yield(message_window, "tree_exited")


func _fail(event, part):
	if event["name"] == "tile_open" and event["tile"].mine:
		return true
	if event["name"] == "time_over":
		return true
	return false

func _prepare_field(mines):
	$Field.reset()
	$Field.distribute_mines(mines)
	$Field.get_safty_tile().swing()
	$OpenSFX.play()

func _solve(part):
	var _result = false
	##################################
	while true:
		var event = yield(Events, "event")
		_play_sfx(event, part)
		_play_gfx(event, part)
		if _fail(event, part):
			_result = false
			break
		if $Field.solved():
			_result = true
			break
	##################################
	if _result:
		$VictorySFX.play()
		yield($VictorySFX, "finished")
	else:
		$BG.show_explosion()
		$FireSFX.play()
		yield($FireSFX, "finished")
	##################################
	return _result
	
func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()
