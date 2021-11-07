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
			_prepare_field(5)
			_message_window(
				[
					"@Добро пожаловать в симуляцию, сержант.",
					"@Пространство поделено на ячейки.",
					"@Есть ячейки в которых установлена взрывчатка.",
					"@Твоя работа - найти эти ячейки и обезвредить.",
					"@Ячейка в которой нет взрывчатки покажет тебе количество соседних ячеек в которых есть взрывчатка.",
					"@Используя эту информацию даже такой идиот как ты сможет все сделать правильно.",
					"@Используй левую кнопку мыши что бы открыть ячейку, используй правую кнопку что бы обезвредить ячейку.",
					"@Любая ошибка недопустима.",
					"@Надеюсь все ясно?"
				]
			)
			while true:
				yield($MessageWindow.get_node("Message"), "change")
				match($MessageWindow.get_node("Message").current_message):
					1:
						$MessageWindow.get_node("Message").rect_position = $MessageWindow.get_node("TopRight").position
					2:
						$Field.open_field()
						$Field.hide_text()
						$OpenSFX.play()
					4:
						$Field.show_text()
						$OpenSFX.play()
					8:
						$MessageWindow.get_node("Message").rect_position = $MessageWindow.get_node("Center").position
						yield($MessageWindow, "tree_exited")
						break
			_start_tutorial(part+1)
			return
		1:
			_prepare_field(1)
			yield(
				_message_window(
					[
						"@Мы спрятали мину на учебном полигоне, сержант.",
						"@Найди её!",
						"@Первая безопасная ячейка крутится.",
						"@Всегда начинай с нее!",
					]
				),
				"completed"
			)
			if (yield(_lust_for_demine(1), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		2:
			_prepare_field(3)
			yield(
				_message_window(
					[
						"@Усложняем.",
						"@В этот раз мы спрятали 3 мины.",
						"@Найди их, сержант!"
					]
				),
				"completed"
			)
			if (yield(_lust_for_demine(3), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		3:
			_prepare_field(4)
			yield(
				_message_window(
					[
						"@Посмотрим как ты справишься с 4"
					]
				),
				"completed"
			)
			if (yield(_lust_for_demine(4), "completed")):
				_start_tutorial(part+1)
			else:
				_start_tutorial(part)
		4:
			yield(
				_message_window(
					[
						"@На этом все.",
						"@Не думаю что ты долго протянешь на настоящем поле.",
						"@Легкой смерти!",
						"#Тебе бы только тренером по мотивации работать."
					]
				),
				"completed"
			)
			get_tree().quit()

func _play_sfx(event):
	if event["name"] == "tile_open":
		$OpenSFX.stop()
		$OpenSFX.play()
	elif event["name"] == "tile_demine":
		$DemineSFX.stop()
		$DemineSFX.play()
		
func _message_window(messages):
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	message_window.get_node("Message").avatar_3 = null
	add_child(message_window, true);
	yield($MessageWindow, "tree_exited")

func _show_fail_message():
	yield(
		_message_window(
			[
				"@Вы идиот, сержант.",
				"@Еще раз, сержант.",
				"@И постарайтесь не быть большим идиотом чем вы есть, сержант."
			]
		),
		"completed"
	)

func _show_success_message():
	yield(
		_message_window(
			[
				"@Очень хорошо, сержант."
			]
		),
		"completed"
	)


func _fail(event):
	if event["name"] == "tile_demine" and not event["tile"].mine:
		return true
	if event["name"] == "tile_open" and event["tile"].mine:
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
	$Music.fade_in()
	while true:
		var event = yield($Field, "change")
		_play_sfx(event)
		$Voice.talk()
		if _fail(event):
			_result = false
			break
		if $Field.demined_tiles() == demine_counter:
			_result = true
			break
	$Music.fade_out()
	##################################
	if _result:
		$VictorySFX.play()
		yield($VictorySFX, "finished")
		yield(_show_success_message(), "completed")
	else:
		$BG.show_explosion()
		$FireSFX.play()
		yield($FireSFX, "finished")
		yield(_show_fail_message(), "completed")
	##################################
	return _result
	
func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()
