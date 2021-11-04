extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	_start_tutorial()

func _start_tutorial():
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
			"@Вперед!"
		],
		false
	)
	############################################################################################################
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
				yield(get_tree().create_timer(0.5), "timeout")
				break
	############################################################################################################
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
	############################################################################################################
	while true:
		var event = yield($Field, "change")
		####################################
		_play_sfx(event)
		####################################
		if _fail(event):
			yield(_show_fail_message(), "completed")
			_start_tutorial()
			return
		if $Field.demined_tiles() == 1:
			yield(get_tree().create_timer(0.5), "timeout")
			break
	############################################################################################################
	_prepare_field(3)
	yield(
		_message_window(
			[
				"@Прекрасная работа, сержант.",
				"@Усложняем.",
				"@В этот раз мы спрятали 3 мины.",
				"@Найди их, сержант!"
			]
		),
		"completed"
	)
	############################################################################################################
	while true:
		var event = yield($Field, "change")
		_play_sfx(event)
		if _fail(event):
			yield(_show_fail_message(), "completed")
			_start_tutorial()
			return
		if $Field.demined_tiles() == 3:
			yield(get_tree().create_timer(0.5), "timeout")
			break
	############################################################################################################
	_prepare_field(5)
	yield(
		_message_window(
			[
				"@Неплохо.",
				"@В этот раз на поле расположено 4 мины.",
				"@Найди их, Сержант!"
			]
		),
		"completed"
	)
	############################################################################################################
	while true:
		var event = yield($Field, "change")
		_play_sfx(event)
		if _fail(event):
			yield(_show_fail_message(), "completed")
			_start_tutorial()
			return
		if $Field.demined_tiles() == 4:
			yield(get_tree().create_timer(0.5), "timeout")
			break
	############################################################################################################
	yield(
		_message_window(
			[
				"@Прекрасно.",
				"@На этом все, сержант.",
				"@Не думаю что ты долго протянешь на настоящем поле.",
				"@Легкой смерти!",
				"#Знаешь, тренер по мотивации из тебя так себе."
			]
		),
		"completed"
	)
	############################################################################################################
	get_tree().quit()

func _play_sfx(event):
	if event["name"] == "tile_open":
		$OpenSFX.stop()
		$OpenSFX.play()
	elif event["name"] == "tile_demine":
		$DemineSFX.stop()
		$DemineSFX.play()
		
func _message_window(messages, wait=true):
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	message_window.get_node("Message").avatar_3 = null
	add_child(message_window, true);
	if wait:
		yield($MessageWindow, "tree_exited")

func _show_fail_message():
	_message_window(
		[
			"@Вы идиот, сержант.",
			"@Еще раз, сержант.",
			"@И постарайтесь не быть большим идиотом чем вы есть, сержант."
		]
	)
	yield($MessageWindow, "tree_exited")
	yield(get_tree().create_timer(0.5), "timeout")


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
