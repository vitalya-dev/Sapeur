extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$Music.play()
	_start_tutorial(3)

func _start_tutorial(part):
	$BG.show_default()
	match part:
		0:
			$Music.fade_out()
			_prepare_field(5)
			yield(
				_message_window(
					[
						"@Отличная работа сержант, но наша работа здесь пока не закончена.",
						"@Отправляйся на територию под мусорный полигон и убедись что там все чисто.",
						"#Разрешите выполнять задание, товарищ полковник?",
						"@Разрешаю. Желаю удачи."
					]
				),
				"completed"
			)
			$Music.fade_in()
			if (yield(_solve(part), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		1:
			$Music.fade_out()
			_prepare_field(5)
			yield(
				_message_window(
					[
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
				),
				"completed"
			)
			$Music.fade_in()
			if (yield(_solve(part), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		2:
			$Music.fade_out()
			_prepare_field(5)
			yield(
				_message_window(
					[
						"#Фьюх. Ну и жара. Что за адская работа."
					]
				),
				"completed"
			)
			$Music.fade_in()
			$BG.blurry()
			if (yield(_solve(part), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		3:
			$Music.fade_out()
			_prepare_field(5)
			# yield(
			# 	_message_window(
			# 		[
			# 			"#Боже мой. что происходит?",
			# 			"#Оператор!!!",
			# 			"$Оператор.",
			# 			"#Свяжите меня немедленно с доктором фон Брауном.",
			# 			"$Соединяю.",
			# 			"*Фон Браун.",
			# 			"#Доктор, по моему меня отравили, все плывет перед глазами.",
			# 			"*О боже мой.",
			# 			"#Мама...",
			# 			"*Кажется я видел таракана на кухне.",
			# 			"#Док!!!",
			# 			"*Ну тише тише голубчик. Ненадо так нервничать.",
			# 			"*Черный баклажан распылил в воздухе Кантаридин. Он замедляет выброс адреналина в кровь.",
			# 			"*Без адреналина твоё сердце остановится. Ничего страшного.",
			# 			"#Боже мой...",
			# 			"*Кантаридин разлагается в организме за пару минут.",
			# 			"*Следите за уровнем адреналина и постарайтесь не умереть голубчик."
			# 		]
			# 	),
			# 	"completed"
			# )
			$Music.fade_in()
			$Scream.play()
			if (yield(_solve(part), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		4:
			_prepare_field(5)
			$Music.fade_in()
			if (yield(_solve(part), "completed")):
				get_tree().quit()
			else:
				_start_tutorial(part)
		

func _play_sfx(event, part):
	if event["name"] == "tile_open":
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
	elif event["name"] == "tile_flag" or event["name"] == "tile_unflag":
		$FlagSFX.stop()
		$FlagSFX.play()
		$Voice.talk()

func _play_gfx(event, part):
	if (event["name"] == "tile_open" or event["name"] == "tile_flag") and part == 3:
		var heart_beat = preload('res://Scenes/HearBeat.tscn').instance()
		add_child(heart_beat)
		heart_beat.rect_position = Vector2(426, 148)
		heart_beat.rect_position -= Vector2(76, 0)
		$Heart.frame = 0
		$Heart.play("alive")


		
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


func _fail(event):
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
		var event = yield($Field, "change")
		_play_sfx(event, part)
		_play_gfx(event, part)
		if _fail(event):
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
