extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_field()
	_show_tutorial_message(0)


func connect_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_demine", self, "_on_tile_demine")


func _on_tile_open(tile):
	$OpenSFX.stop()
	$OpenSFX.play()


func _on_tile_demine(tile):
	$DemineSFX.stop()
	$DemineSFX.play()

func _show_tutorial_message(step):
	var message_window = preload('res://Scenes/MessageWindow.tscn').instance()
	message_window.get_node("Message").messages = [
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
	message_window.get_node("Message").connect("showing_current_message", self, "_tutorial_message_showing")
	############################################################################################################
	add_child(message_window, true);


	
func _tutorial_message_showing(i):
	match(i):
		0:
			$MessageWindow.get_node("Message").rect_position = $MessageWindow.get_node("TopRight").position
		1:
			$Field.distribute_mines(5)
			$Field.open_field()
			$Field.hide_text()
			$OpenSFX.play()
		2:
			pass
		3:
			$Field.show_text()
			$OpenSFX.play()
		4:
			pass
		5:
			pass
		6:
			pass
		7:
			pass
				
				

			
