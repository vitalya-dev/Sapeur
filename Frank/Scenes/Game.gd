extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_current_level()

func _on_level_complete():
	current_level += 1
	$Level.queue_free()
	_load_current_level()

func _load_current_level():
	var level = load('res://Scenes/Level_%d/Level_%d.tscn' % [current_level, current_level]).instance()
	level.connect("complete", self, "_on_level_complete")
	add_child(level, true);

func _input(ev):
	print("Input")
	if ev.is_action_pressed("ui_cancel"):
		_show_menu(get_node_or_null("Menu"))


func _show_menu(current_menu):
	if current_menu:
		current_menu.emit_signal("button_pressed", "continue")
	else:
		get_tree().paused = true	
		var menu = preload('res://Scenes/Menu.tscn').instance()
		add_child(menu, true);
		var button_name = yield(menu, "button_pressed")
		if button_name == "continue":
			get_tree().paused = false	
			menu.queue_free()
		if button_name == "exit":
			get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
