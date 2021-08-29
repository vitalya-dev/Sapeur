extends Control

var SIZE = Vector2(10, 10)
var MINES = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Game.rect_size = Vector2(0, 0)
	make_tiles()
	distribute_mines()
	set_neighbors()
	#adjust_window_size();
	switch_full_screen();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()

func make_tiles():
	$Game/Field.set_columns(SIZE.x)
	for y in range(SIZE.y):
		for x in range(SIZE.x):
			var tile = preload('res://Tile.tscn').instance()
			tile.rect_position = Vector2(x,y);
			tile.connect("open", self, '_on_tile_open', [Vector2(x, y)])
			$Game/Field.add_child(tile);
			
func distribute_mines():
	randomize()
	var mines_count = MINES
	while mines_count > 0:
		var minepos = randi() % int(SIZE.x * SIZE.y)
		if not $Game/Field.get_child(minepos).mine:
			$Game/Field.get_child(minepos).mine = true
			mines_count -= 1	

func set_neighbors():
	for y in range(SIZE.y):
		for x in range(SIZE.x):
			var mines = 0
			var pos = Vector2(x, y)
			for neighbor in get_neighbors(pos):
				if get_tile(neighbor).mine:
					mines += 1
			get_tile(pos).mines_around = mines

func get_tile(pos):
	return $Game/Field.get_child(pos.x + (pos.y * SIZE.x))

func get_neighbors(pos):
	var neighbors = []
	for delta_x in [-1, 0, 1]:
		for delta_y in [-1, 0, 1]:
			var neighbor = Vector2(pos.x + delta_x, pos.y + delta_y)
			if neighbor.x < 0 or neighbor.x >= SIZE.x:
				continue
			if neighbor.y < 0 or neighbor.y >= SIZE.y:
				continue
			if neighbor.x == pos.x and neighbor.y == pos.y:
				continue
			neighbors.append(neighbor)
	return neighbors;
				
func adjust_window_size():
	yield(get_tree(), "idle_frame")
	OS.set_window_size($Game.rect_size)
	
	
func switch_full_screen():
	yield(get_tree(), "idle_frame")
	OS.window_fullscreen = true

func _on_tile_open(pos):
	if get_tile(pos).mines_around == 0:
		for neighbor in get_neighbors(pos):
			get_tile(neighbor).open()
