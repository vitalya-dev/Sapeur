extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$Music.play()
	_start_mission(0)

func _start_mission(part):
	match part:
		0:
			$BG.show_default()
			$Music.fade_in()
			_start_mission(part+1)
			return
		1:
			while $Music.is_playing():
				_prepare_field(5)
				if (yield(_solve(part), "completed")):
					$VictorySFX.play()
					yield($VictorySFX, "finished")
					#===========================#
					continue
				else:
					$BG.show_explosion()
					#===========================#
					$FireSFX.play()
					yield($FireSFX, "finished")
					#===========================#
					$BG.show_default()
					#===========================#
					continue
			_start_mission(part+1)
		2:
			$Field.visible = false
			$BG.show_glory()
			#===========================#
			$VictorySFX.play()
			yield($VictorySFX, "finished")
			#===========================#
			var grade = preload('res://Scenes/Grade.tscn').instance()
			add_child(grade, true);
			grade.position = Vector2(63, 53)
			grade.stamped("A")
			#===========================#
			while (yield(Events, "event")["owner"] != "mouse"):
				pass
			get_tree().quit()


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


func _prepare_field(mines):
	$Field.reset()
	$Field.distribute_mines(mines)
	$Field.get_safty_tile().swing()
	$OpenSFX.play()



func _failed(event, part):
	if event["name"] == "tile_open" and event["tile"].mine:
		return true
	else:
		return false

func _solved(event, part):
	if event["owner"] == "music" and event["name"] == "finished":
		return true
	elif $Field.solved():
		return true
	else:
		return false

func _solve(part):
	var _result = null
	##################################
	while true:
		var event = yield(Events, "event")
		_play_sfx(event, part)
		_play_gfx(event, part)
		if _failed(event, part):
			_result = false
			break
		if _solved(event, part):
			_result = true
			break
	##################################
	return _result
	
func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()
