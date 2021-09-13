extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	switch_full_screen()
	init_field()
	init_hud()
	show_intro_message()
	wait_for_message()

func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		quit()

func quit():
	get_tree().quit()

func switch_full_screen():
	yield(get_tree(), "idle_frame")
	OS.window_fullscreen = true


func init_field():
	$Field.connect("tile_open", self, "_on_tile_open")
	$Field.connect("tile_flagged", self, "_on_tile_flagged")
	$Field.connect("tile_unflagged", self, "_on_tile_unflagged")
	
func init_hud():
	for i in range($Field.flags):
		$HUD.push_flag()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#pass

func _on_tile_open(tile):
	if tile.mine:
		$Field.state = "FAIL"
		$BG.color = Color("#000000")
		yield(get_tree().create_timer(2), "timeout")
		show_fail_message()
				
func _on_tile_flagged(tile):
	$HUD.pop_flag()
	if is_win():
		$Field.state = "WIN"
		$Field.show_white_background()
		show_win_message()

func _on_tile_unflagged(tile):
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

func wait_for_message():
	var field_previous_state = $Field.state
	$Field.state = "WAIT"
	while (get_node_or_null("Message")):
		yield(get_tree().create_timer(0.5), "timeout")
	$Field.state = field_previous_state

func is_win():
	if $Field.flags > 0:
		return false
	for tile in get_tree().get_nodes_in_group("flagged"):
		if not tile.mine:
			return false
	return true

func is_fail():
	for tile in get_tree().get_nodes_in_group("open"):
		if tile.mine:
			return true
	return false



