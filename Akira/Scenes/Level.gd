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
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = [
		"@Добро пожаловать в симуляцию, сержант.",
		"@Пространство поделено на ячейки.",
		"@Есть ячейки в которых установлена взрывчатка.",
		"@Твоя работа - найти эти ячейки и обезвредить.",
		"@Ячейка в которой нет взрывчатки покажет тебе количество соседних ячеек в которых есть взрывчатка.",
		"@Используя эту информацию даже такой идиот как ты сможет все сделать правильно.",
		"@Используй левую кнопку мыши что бы открыть ячейку, используй правую кнопку что бы обезвредить ячейку.",
		"@Любая ошибка недопустима.",
		"@Вперед!"
	]
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	############################################################################################################
	add_child(message_window, true);
	############################################################################################################
	while true:
		yield(message_window.get_node("Message"), "change")
		match(message_window.get_node("Message").current_message):
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
				yield(message_window, "tree_exited")
				break
	############################################################################################################
	$Field.mines = 1
	yield(get_tree().create_timer(1), "timeout")
	$Field.reset()
	$OpenSFX.play()
	yield(get_tree().create_timer(0.5), "timeout")
	############################################################################################################
	message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = [
		"@Мы спрятали мину на учебном полигоне, сержант.",
		"@Найди её!"
	]
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	############################################################################################################
	add_child(message_window, true);
	############################################################################################################
	yield(message_window, "tree_exited")
			
