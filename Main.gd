extends Control

var SIZE = Vector2(10, 10)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Game.rect_size = Vector2(0, 0)
	make_tiles()
	adjust_window_size();
	switch_full_screen();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($Game.rect_size);

func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()

func make_tiles():
	$Game/Field.set_columns(SIZE.x)
	for y in range(SIZE.y):
		for x in range(SIZE.x):
			var tile = preload('res://Tile.tscn').instance()
			tile.rect_position = Vector2(x,y);
			$Game/Field.add_child(tile);
	
			
func adjust_window_size():
	yield(get_tree(), "idle_frame")
	OS.set_window_size($Game.rect_size)
	
	
func switch_full_screen():
	yield(get_tree(), "idle_frame")
	OS.window_fullscreen = true
