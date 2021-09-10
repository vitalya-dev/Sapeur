extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	init_field()
	init_hud()
	show_intro_message()
	while (get_node_or_null("Message")):
		yield(get_tree().create_timer(0.5), "timeout")
	$Field.active(true)


func init_field():
	$Field.connect("win", self, "_on_win")
	$Field.connect("fail", self, "_on_fail")
	$Field.connect("tile_flagged", self, "_on_tile_flagged")
	$Field.connect("tile_unflagged", self, "_on_tile_unflagged")
	$Field.active(false)
	
func init_hud():
	for i in range($Field.flags):
		$HUD.push_flag()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#pass


func _on_fail():
	yield(get_tree().create_timer(1), "timeout")
	show_fail_message()

func _on_win():
	yield(get_tree().create_timer(1), "timeout")
	show_win_message()

func _on_tile_flagged():
	$HUD.pop_flag()

func _on_tile_unflagged():
	$HUD.push_flag()


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
