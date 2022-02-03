extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var scores_in_sec = 40

var mission_text_1 = [
	"@Замечательная работа Сержант.",
	"@Последний заход.",
	"@Будьте осторожны."
]

var mission_text_2 = [
	"$Сержант вам входящий.",
	"#Соединяйте.",
	"%Скотина!",
	"%Ты почему не дал ребенку то о чем он тебя просил, чудовище?",
	"%Из за тебя мой птенчик грустит!",
	"%Подонок.",
	"$Соединение прервано.",
	"#...!",
	"#За что мне все вот это вот?"
]

var mission_text_3 = [
	"#Оператор.",
	"$Оператор.",
	"#Да. Соедините меня с моим братом.",
	"&Алло?",
	"#Мурло!",
	"#Можешь взять приставку."
]

var mission_text_4 = [
	"@Cержант.",
	"#Домой, товарищ полковник?",
	"#...",
	"#Полковник?",
	"@Cержант.",
	"@Зови меня...",
	")...Ахмед ибн Юсуф."
]

var music_1 = preload("res://Assets/Sounds/The Gauntlet [POKEY Original]-714991828.mp3")
var music_2 = preload("res://Assets/Sounds/Bounty Battle - Animated Trailer theme-892202470.mp3")

signal complete()

# Called when the node enters the scene tree for the first time.
func _ready():
	$BG.show_default(3)
	_mission(0)

func _mission(part):
	yield(Engine.get_main_loop(), "idle_frame")
	match part:
		0:
			yield(get_tree().create_timer(0.5), "timeout")
			yield(_show_text(mission_text_1), "completed")
			$Music.stream = music_1			
			$Music.play()
			$Music.fade_in()
			_mission(part+1)
			return
		1:
			yield(_play_while_music_play(), "completed")
			_mission(part+1)
			return
		2:
			yield(_show_text(mission_text_2), "completed")
			$Music.stream = music_2
			$Music.play()
			$Music.fade_in()
			_mission(part+1)
			return
		3:
			yield(_play_while_music_play(), "completed")
			_mission(part+1)
			return
		4:
			yield(_show_text(mission_text_3), "completed")
			_mission(part+1)
			return
		5:
			yield(_play_final_screen(), "completed")
			_stamped_mark()
			yield(get_tree().create_timer(0.5), "timeout")
			while (yield(Events, "event")["owner"] != "mouse"):
				pass
			_mission(part+1)
			return
		_:
			emit_signal("complete")
			return 
		

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
		_prepare_field(5)
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
			$BG.show_default(3)
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

func _play_gfx(event):
	pass

		
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
	top_score += music_1.get_length() * scores_in_sec
	top_score += music_2.get_length() * scores_in_sec
	
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
		_play_gfx(event)
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
	
func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()
