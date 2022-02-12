extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var scores_in_sec = 40

var mission_text_1 = [
	"@Добро пожаловать в Алжир сержант.",
	"@Местные заминировали часть Сахары на подьезде к городу.",
	"@Наша задача - разминировать то что они заминировали.",
	"@Вопросы?",
	"#Никак нет.",
	"#Разрешите выполнять задание?",
	"@Разрешаю.",
	"@Желаю удачи."
]

var mission_text_2 = [
	"$Сержант вам входящий.",
	"#Соединяйте.",
	"%ТЫ ЧЕГО МНЕ НЕ ЗВОНИШЬ СКОТИНА?",
	"#Мам!!!",
	"#Я на работе!!!",
	"%Ага на работе он. Твой брат все рассказал на какой ты работе.",
	"%Загораешь под солнцем и даже свою мать не пригласил.",
	"%Ты ведь знаешь как мне нужен витамин D.",
	"#Мам. Я не на курорте. Тут мины кругом. Очень опасно.",
	"%Очень опасно было тебя рожать. Ты меня чуть не убил при родах. Безсердечное ты животное.",
	"%Из за тебя у меня было внутрнее кравотечение.",
	"%А сейчас сердце кровью обливается от того что бывают такие неблагодарные дети.",
	"%Сукин ты сын...",
	"$Соеденение прервано.",
	"#Господи...",
]

var mission_text_3= [
	"$Сержант Вам входящий.",
	"%Надо было отдать тебя в детдом а еще лучше вообще не рожать!",
	"$Соеденение прервано.",
	"#...",
	"#Что за день."
]



signal complete()

# Called when the node enters the scene tree for the first time.
func _ready():
	music = [preload("res://Assets/Sounds/ahoe.mp3"), preload("res://Assets/Sounds/Mimosa-697049527.mp3")]
	$BG.show_default(1)
	yield(get_tree(), "idle_frame")
	_mission(0)

func _mission(part):
	if is_queued_for_deletion():
		return
	match part:
		0:
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
			$BG.show_default(1)
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
