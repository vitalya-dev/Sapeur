extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Field.connect("win", self, "_on_win")
	$Field.connect("fail", self, "_on_fail")
	$Field.active(false)
	show_intro_message()
	while (get_node("Message")):
		yield(get_tree().create_timer(0.5), "timeout")
	$Field.active(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#pass


func _on_init():
	yield(get_tree().create_timer(0.5), "timeout")
	$Field.active(false)
	show_intro_message()

func _on_fail():
	yield(get_tree().create_timer(1), "timeout")
	show_fail_message()


func _on_win():
	yield(get_tree().create_timer(1), "timeout")
	show_win_message()


func show_intro_message():
	var message = preload('res://Scenes/Message.tscn').instance()
	message.messages = ["@Это учебное задание.", "@Обезвредь все мины, сержант.", "#Будет исполнено, товарищ полковник."]
	message.avatar_1 = preload("res://Assets/avatar_colonel.png")
	message.avatar_2 = preload("res://Assets/avatar_sergeant.png")
	add_child(message, true);

func show_win_message():
	var message = preload('res://Scenes/Message.tscn').instance()
	message.messages = ["@Прекрасная работа, сержант.", "#Спасибо товарищ, полковник."]
	message.avatar_1 = preload("res://Assets/avatar_colonel.png")
	message.avatar_2 = preload("res://Assets/avatar_sergeant.png")
	add_child(message);

func show_fail_message():
	var message = preload('res://Scenes/Message.tscn').instance()
	message.messages = [
		"@Черт возьми, сержант.",
		"@Ты просто позор наших славных вооруженых сил.",
		"#Прошу меня извенить, товарищ полковник."]
	message.avatar_1 = preload("res://Assets/avatar_colonel.png")
	message.avatar_2 = preload("res://Assets/avatar_sergeant.png")
	add_child(message);
