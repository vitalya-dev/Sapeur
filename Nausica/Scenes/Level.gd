extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$Music.play()
	_start_tutorial(2)

func _start_tutorial(part):
	$BG.show_default()
	match part:
		0:
			$Music.fade_out()
			_prepare_field(10)
			yield(
				_message_window(
					[
						"@Доброе утро Сержант.",
						"@В Алжир съежаются важные шишки.",
						"@Их задача - закопать радиоактивный мусор в пустыне.",
						"@Президенту Ранаяну пообещали приз если он пойдет на это.",
						"@Терористам из группировки \"черный баклажан\" эта преспектива крайне ненравится.",
						"@Они заминировали часть Сахары на подьезде к Алжиру.",
						"@Задача нашей ЧВК - не один толстосум не должен превратиться в мокрое место на песочке.",
						"@Вопросы?",
						"#Никак нет.",
						"#Разрешите выполнять задание?",
						"@Разрешаю.",
						"@Желаю удачи."
					]
				),
				"completed"
			)
			$Music.fade_in()
			if (yield(_lust_for_demine(10), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		1:
			$Music.fade_out()
			_prepare_field(10)
			yield(
				_message_window(
					[
						"$Сержант вам входящий.",
						"#Соединяйте.",
						"%ТЫ ЧЕГО МНЕ НЕ ЗВОНИШЬ СКОТИНА?",
						"#Мам!!!",
						"#Как ты сюда дозвонилась!!!",
						"#Это закрытая линия!!!",
						"#Вроде бы...",
						"#А впрочем не важно.",
						"#Я на работе Мам!!!",
						"%Ага на работе он. Твой брат все рассказал на какой ты работе.",
						"%Загораешь под солнцем и даже свою мать не пригласил.",
						"%Ты ведь знаешь как мне нужен витамин D.",
						"#Мам. Я не на курорте. Тут мины кругом. Очень опасно.",
						"%Очень опасно было тебя рожать. Ты меня чуть не убил при родах. Безсердечное ты животное.",
						"#Господи, я был младенцем, я же не специально.",
						"%Из за тебя у меня было внутрнее кравотечение.",
						"%А сейчас сердце кровью обливается от того что бывают такие неблагодарные дети.",
						"#Мам!!!",
						"%Сукин ты сын...",
						"$Соеденение прервано.",
						"#Господи...",
						"#Ладно, продолжаем."
					]
				),
				"completed"
			)
			$Music.fade_in()
			if (yield(_lust_for_demine(10), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		2:
			$Music.fade_out()
			_prepare_field(5)
			yield(
				_message_window(
					[
						"$Сержант вам входящий.",
						"#Боже, что опять. Соединяйте.",
						"^ЬМЕЛФТЙЖЙЛБГЙС АЦОЩИ!",
						"#Что? Я ничего не понял!",
						"^ыЙТПЛБС!!!",
						"#...",
						"@Сержант у нас проблемы.",
						"@Черный баклажан активировал таймер на минах.",
						"@У тебя 10 секунд что бы обезвредить их всех."
					]
				),
				"completed"
			)
			$Scream.play()
			$Music.fade_in()
			$Field.get_node("Timer").play()
			if (yield(_lust_for_demine(5), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
			
		3:
			$Music.fade_out()
			$Field.get_node("Timer").stop()
			yield(get_tree().create_timer(3), "timeout")
			get_tree().quit()

func _play_sfx(event):
	if event["name"] == "tile_open":
		$OpenSFX.stop()
		$OpenSFX.play()
		$Voice.talk()
	elif event["name"] == "tile_demine":
		$DemineSFX.stop()
		$DemineSFX.play()
		$Voice.talk()

		
func _message_window(messages):
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_colonel.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	message_window.get_node("Message").avatar_3 = preload("res://Assets/Graphics/Avatars/avatar_operator.png")
	message_window.get_node("Message").avatar_4 = preload("res://Assets/Graphics/Avatars/avatar_mom.png")
	message_window.get_node("Message").avatar_5 = preload("res://Assets/Graphics/Avatars/avatar_bomber.png")
	add_child(message_window, true);
	yield(message_window, "tree_exited")


func _fail(event):
	if event["name"] == "tile_demine" and not event["tile"].mine:
		return true
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

func _lust_for_demine(demine_counter):
	var _result = false
	##################################
	while true:
		var event = yield($Field, "change")
		_play_sfx(event)
		if _fail(event):
			_result = false
			break
		if $Field.demined_tiles() == demine_counter:
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
