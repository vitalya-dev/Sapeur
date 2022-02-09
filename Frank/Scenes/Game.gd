extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_level = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_current_level()

func _on_level_complete():
	current_level += 1
	$Level.queue_free()
	remove_child($Level)
	_load_current_level()

func _load_current_level():
	var level = load('res://Scenes/Level_%d/Level_%d.tscn' % [current_level, current_level]).instance()
	level.connect("complete", self, "_on_level_complete")
	add_child(level)

func show_menu():
	get_tree().paused = true	
	###############################################################
	var menu = preload('res://Scenes/Menu.tscn').instance()
	add_child(menu);
	###############################################################
	var result = yield(menu, "button_pressed")
	if result == "continue":
		yield(get_tree(), "idle_frame")
		get_tree().paused = false	
		menu.queue_free()
	if result == "exit":
		$Level.queue_free()
		yield($Level, "tree_exited")
		quit_game()

func quit_game():
	get_tree().quit()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
