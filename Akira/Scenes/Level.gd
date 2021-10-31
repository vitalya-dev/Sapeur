extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_field()
	_start_tutorial()


func connect_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_demine", self, "_on_tile_demine")


func _on_tile_open(_tile):
	$OpenSFX.stop()
	$OpenSFX.play()


func _on_tile_demine(_tile):
	$DemineSFX.stop()
	$DemineSFX.play()

func _start_tutorial():
	$Field.reset()
	############################################################################################################
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
		preload("res://Assets/Graphics/Avatars/avatar_doctor.png"),
		preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	)
	############################################################################################################
	while true:
		yield($MessageWindow.get_node("Message"), "change")
		match($MessageWindow.get_node("Message").current_message):
			1:
				$MessageWindow.get_node("Message").rect_position = $MessageWindow.get_node("TopRight").position
			2:
				$Field.distribute_mines(5)
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
	############################################################################################################
	yield(get_tree().create_timer(1), "timeout")
	############################################################################################################
	$Field.reset()
	$Field.distribute_mines(1)
	$OpenSFX.play()
	############################################################################################################
	yield(get_tree().create_timer(0.5), "timeout")
	############################################################################################################
	_message_window(
		[
			"@Мы спрятали мину на учебном полигоне, сержант.",
			"@Найди её!"
		],
		preload("res://Assets/Graphics/Avatars/avatar_doctor.png"),
		preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	)
	yield($MessageWindow, "tree_exited")
	############################################################################################################
	while true:
		var event = yield($Field, "change")
		if event["name"] == "tile_demine" and event["tile"].mine:
			_message_window(
				[
					"@Прекрасная работа, сержант."
				],
				preload("res://Assets/Graphics/Avatars/avatar_doctor.png"),
				preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
			)
			yield($MessageWindow, "tree_exited")
			yield(get_tree().create_timer(1), "timeout")
			break;
		if event["name"] == "tile_demine" and not event["tile"].mine:
			_message_window(
				[
					"@Вы идиот, сержант.",
					"@Еще раз, сержант.",
					"@И постарайтесь не быть большим идиотом чем вы есть, сержант."
				],
				preload("res://Assets/Graphics/Avatars/avatar_doctor.png"),
				preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
			)
			yield($MessageWindow, "tree_exited")
			yield(get_tree().create_timer(1), "timeout")
			_start_tutorial()
			return
	############################################################################################################
	$Field.reset()
	$Field.distribute_mines(3)
	$OpenSFX.play()
	############################################################################################################
	_message_window(
		[
			"@Усложняем, сержант.",
			"@В этот раз мы спрятали 3 мины, сержант.",
			"@Найди их!"
		],
		preload("res://Assets/Graphics/Avatars/avatar_doctor.png"),
		preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	)
	yield($MessageWindow, "tree_exited")
	############################################################################################################
	while true:
		var event = yield($Field, "change")
		if event["name"] == "tile_demine" and not event["tile"].mine:
			_message_window(
				[
					"@Вы просто неисправимые дегенират, сержант.",
					"@Еще раз, сержант.",
					"@И постарайтесь в этот раз, сержант."
				],
				preload("res://Assets/Graphics/Avatars/avatar_doctor.png"),
				preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
			)
			yield($MessageWindow, "tree_exited")
			############################################################################################################
			yield(get_tree().create_timer(1), "timeout")
			_start_tutorial()
			return
			
func _message_window(messages, avatar_1=null, avatar_2=null, avatar_3=null):
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = messages
	message_window.get_node("Message").avatar_1 = avatar_1
	message_window.get_node("Message").avatar_2 = avatar_2
	message_window.get_node("Message").avatar_3 = avatar_3
	add_child(message_window, true);

