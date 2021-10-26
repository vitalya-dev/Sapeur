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
		"@Добро пожаловать на полигон, сержант.",
		"@Пространство поделено на ячейки.",
		"@Есть ячейки в которых установлена взрывчатка.",
		"@Твоя работа - найти эти ячейки и обезвредить.",
		"@Ячейка в которой нет взрывчатки покажет тебе количество соседних ячеек в которых есть взрывчатка.",
		"@Используя эту информацию даже такой идиот как ты сможет все сделать правильно.",
		"@Используй левую кнопку мыши что бы открыть ячейку, используй правую кнопку что бы обезвредить ячейку.",
		"@Любая ошибка недопустима.",
		"@Обезвредишь ячейку в которой нет взрывчатки - будет взрыв.",
		"@Откроешь ячейку в которой есть взрывчатка - будет взрыв.",
		"@Ну? Чего ты ждешь?",
		"@Вперед!"
	]
	message_window.get_node("Message").avatar_1 = preload("res://Assets/Graphics/Avatars/avatar_doctor.png")
	message_window.get_node("Message").avatar_2 = preload("res://Assets/Graphics/Avatars/avatar_sergeant.png")
	add_child(message_window, true);
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
