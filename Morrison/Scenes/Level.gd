extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mission_text_1 = [
	"@Отличная работа сержант, но наша работа здесь пока не закончена.",
	"@Отправляйся на територию под мусорный полигон и убедись что там все чисто.",
	"#Разрешите выполнять задание, товарищ полковник?",
	"@Разрешаю. Желаю удачи."
]

var mission_text_2 = [
	"$Сержант вам входящий.",
	"#Соединяйте.",
	"&Привет Брат.",
	"#Ну погоди. Ну все. Устрою тебе. И это закрытая линия!!!",
	"&А что я такого сделал?",
	"#Кто сказал маме что я на курорте?",
	"#Отдыхаю под солнышком? А?",
	"#Хороший курорт, оторванные руки-ноги за счет туроператора да?",
	"&Да ничего я такого ей не говорил.",
	"&Она спросила где ты я ответил а она что то себе придумала.",
	"#Ну все... Ну все... Теперь ты у меня получишь...",
	"#Думал по телефону меня задобрить да? черта с два.",
	"#Ну все... Ну все...",
	"&Да я вообще не поэтому звоню.",
	"#Не по этому он звонит. Не поэтому он звонит. Что ты еще натворил?",
	"&Да что ты в самом деле. Я просто подумал раз ты сейчас не дома...",
	"#... а на курорте. Да это я уже понял. Дальше давай у меня мало времени.",
	"&... то я могу взять твою приставку поиграть.",
	"&Чего ей просто пылиться без дела, правда же?",
	"#Ааа. Ну конечно, конечно миленький возьми.",
	"#Неужели мне что то жалко для любимого братика.",
	"#После всего что ты мне сделал, да?",
	"&Ну ладно, не хочешь как хочешь.",
	"#Не хочешь как хочешь? Тебе что",
	"$Соеденение прервано.",
	"#Трубку повесил. Ну все. Я ему устрою. Ну все."
]

var mission_text_3 = [
	"$Сержант вам входящий.",
	"#А?",
	"(Привет любимый.",
	"(Твой брат заходил.",
	"(Взял твою дурацкую приставку. Сказал что ты разрешил.",
	"(И еще съел все вафли маленького.",
	"#Ну все, ну все..."
]



# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	_mission(0)

func _mission(part):
	match part:
		0:
			yield(_show_text(mission_text_1), "completed")
			$Music.stream = preload("res://Assets/Sounds/Kirby - Gourmet Race (Electro_Chiptune) remix-136724831.mp3")
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
			$Music.stream = preload("res://Assets/Sounds/ahoe.mp3")
			$Music.play()
			$Music.fade_in(25)
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
			print($Score.value)
			yield(_play_final_screen(), "completed")
			_stamped_mark()
			_mission(part+1)
			return
		_:
			yield(get_tree().create_timer(0.5), "timeout")
			while (yield(Events, "event")["owner"] != "mouse"):
				pass
			get_tree().quit()


func _play_final_screen():
	$Field.visible = false
	$BG.show_glory()
	#===========================#
	$VictorySFX.play()
	yield($VictorySFX, "finished")

func _stamped_mark():
	var grade = preload('res://Scenes/Grade.tscn').instance()
	add_child(grade, true);
	grade.position = Vector2(63, 53)
	grade.stamped("A")	


func _show_text(text):
	$BG.show_default()
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
			$BG.show_default()
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
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_colonel.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	message_window.get_node("Message").avatar_3 = preload("res://Assets/Graphics/Avatars/avatar_operator.png")
	message_window.get_node("Message").avatar_4 = preload("res://Assets/Graphics/Avatars/avatar_mom.png")
	message_window.get_node("Message").avatar_5 = preload("res://Assets/Graphics/Avatars/avatar_bomber.png")
	message_window.get_node("Message").avatar_6 = preload("res://Assets/Graphics/Avatars/avatar_brother.png")
	message_window.get_node("Message").avatar_7 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message_window.get_node("Message").avatar_8 = preload("res://Assets/Graphics/Avatars/avatar_wife.png")
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
