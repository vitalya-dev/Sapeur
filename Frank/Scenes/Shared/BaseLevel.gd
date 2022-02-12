extends Control

# Declare member variables here. Examples
export(int) var scores_in_sec = 50
export(int) var mines = 5
export (int) var bg_frame = 0

var music = []

signal complete()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _start_level():
	$BG.show_default(bg_frame)
	yield(get_tree(), "idle_frame")
	_mission(0)

func _mission(part):
	pass

func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		_esc_pressed()

func _esc_pressed():
	get_node("/root/Game").show_menu() 

func _play_final_screen():
	$Field.visible = false
	$BG.show_glory()
	#===========================#
	$VictorySFX.play()
	yield($VictorySFX, "finished")

func _play_credits_screen():
	$Field.visible = false
	$BG.show_credits()
	#===========================#
	$VictorySFX.play()
	yield($VictorySFX, "finished")

func _stamped_mark():
	var grade = preload('res://Scenes/Shared/Grade.tscn').instance()
	add_child(grade, true);
	grade.position = Vector2(63, 53)
	grade.stamped(_score_to_mark($Score.value))	

func _hide_mark():
	$Grade.queue_free()

func _show_text(text):
	_prepare_field(0)
	yield(_message_window(text), "completed")

func _play_while_music_play():
	while $Music.is_playing():
		_prepare_field(mines)
		if (yield(_solve(), "completed")):
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
			$BG.show_default(bg_frame)
			#===========================#
			continue	

func _play_sfx(event):
	if event["owner"] == "field" and event["name"] == "tile_open":
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
	elif event["owner"] == "field" and (event["name"] == "tile_flag" or event["name"] == "tile_unflag"):
		$FlagSFX.stop()
		$FlagSFX.play()
		$Voice.talk()

		
func _message_window(messages):
	var message_window = preload('res://Scenes/Shared/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_colonel.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	message_window.get_node("Message").avatar_3 = preload("res://Assets/Graphics/Avatars/avatar_operator.png")
	message_window.get_node("Message").avatar_4 = preload("res://Assets/Graphics/Avatars/avatar_mom.png")
	message_window.get_node("Message").avatar_5 = preload("res://Assets/Graphics/Avatars/avatar_bomber.png")
	message_window.get_node("Message").avatar_6 = preload("res://Assets/Graphics/Avatars/avatar_brother.png")
	message_window.get_node("Message").avatar_7 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message_window.get_node("Message").avatar_8 = preload("res://Assets/Graphics/Avatars/avatar_wife.png")
	message_window.get_node("Message").avatar_9 = preload("res://Assets/Graphics/Avatars/avatar_ahmed.png")
	message_window.get_node("Message").avatar_10 = preload("res://Assets/Graphics/Avatars/avatar_ahmed_dead.png")
	add_child(message_window, true);
	yield(message_window, "tree_exited")


func _prepare_field(mines):
	$Field.reset()
	$Field.distribute_mines(mines)
	$Field.get_safty_tile().swing()
	$OpenSFX.play()



func _failed(event):
	if event["name"] == "tile_open" and event["tile"].mine:
		return true
	else:
		return false

func _solved(event):
	if event["owner"] == "music" and event["name"] == "finished":
		return true
	elif $Field.solved():
		return true
	else:
		return false

func _add_score(event):
	if event["name"] == "tile_open":
		$Score.value += 5
	elif event["name"] == "tile_flag":
		$Score.value += 1
	elif event["name"] == "tile_unflag":
		$Score.value += 1

func _score_to_mark(score):
	var top_score = 0
	for i in music:
		top_score += i.get_length() * scores_in_sec
	
	if score > top_score:
		return "A"
	elif score > top_score * 0.8:
		return "B"
	elif score > top_score * 0.6:
		return "C"
	elif score > top_score * 0.4:
		return "D"
	else:
		return "F"



func _solve():
	var _result = null
	##################################
	while true:
		var event = yield(Events, "event")
		_play_sfx(event)
		_add_score(event)
		if _failed(event):
			_result = false
			$Score.value -= 300
			break
		elif _solved(event):
			_result = true
			$Score.value += 150
			break
	##################################
	return _result
