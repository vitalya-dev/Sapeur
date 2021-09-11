extends Control

export var size : Vector2
export var mines : int
export var flags : int

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


signal tile_flagged(tile)
signal tile_open(tile)
signal tile_unflagged(tile)

var state = "GAME"
var debug_font = make_font(24)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.rect_size = Vector2(0, 0)
	make_tiles()
	distribute_mines()
	set_neighbors()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		"GAME":
			pass

func _draw():
	#draw_string(debug_font, Vector2(0, 24), state, Color(1.0, 1.0, 1.0))
	pass
	
func make_tiles():
	$Panel/Grid.set_columns(size.x)
	for y in range(size.y):
		for x in range(size.x):
			var tile = preload('res://Scenes/Tile.tscn').instance()
			tile.connect("lmb", self, "_on_tile_lmb", [Vector2(x, y)])
			tile.connect("rmb", self, "_on_tile_rmb", [Vector2(x, y)])
			$Panel/Grid.add_child(tile)
			
func distribute_mines():
	randomize()
	var mines_count = mines
	while mines_count > 0:
		var minepos = randi() % int(size.x * size.y)
		if not $Panel/Grid.get_child(minepos).mine:
			$Panel/Grid.get_child(minepos).mine = true
			mines_count -= 1	

func set_neighbors():
	for y in range(size.y):
		for x in range(size.x):
			var mines_around = 0
			var pos = Vector2(x, y)
			for neighbor in get_neighbors(pos):
				if get_tile(neighbor).mine:
					mines_around += 1
			get_tile(pos).mines_around = mines_around

func get_tile(pos):
	return $Panel/Grid.get_child(pos.x + (pos.y * size.x))

func get_neighbors(pos):
	var neighbors = []
	for delta_x in [-1, 0, 1]:
		for delta_y in [-1, 0, 1]:
			var neighbor = Vector2(pos.x + delta_x, pos.y + delta_y)
			if neighbor.x < 0 or neighbor.x >= size.x:
				continue
			if neighbor.y < 0 or neighbor.y >= size.y:
				continue
			if neighbor.x == pos.x and neighbor.y == pos.y:
				continue
			neighbors.append(neighbor)
	return neighbors;
				

func _on_tile_lmb(tile, tile_pos):
	if state == "GAME":
		_on_tile_open(tile, tile_pos)

func _on_tile_open(tile, tile_pos):
	match tile.state:
		"FLAGGED":
			_on_tile_rmb(tile, tile_pos)
			continue
		"FLAGGED", "NORMAL":
			tile.open()
			emit_signal("tile_open", tile)
			if tile.mines_around == 0:
				for neighbor in get_neighbors(tile_pos):
					_on_tile_open(get_tile(neighbor), neighbor)

func _on_tile_rmb(tile, tile_pos):
	if state == "GAME":
		_on_tile_flag(tile, tile_pos)
			

func _on_tile_flag(tile, tile_pos):
	match tile.state:
		"NORMAL":
			if flags > 0:
				flags -= 1
				tile.flag()
				emit_signal("tile_flagged", tile)
		"FLAGGED":
			flags += 1
			tile.unflag()
			emit_signal("tile_unflagged", tile)

func make_font(font_size):
	var font = DynamicFont.new()
	font.size = font_size
	font.set_font_data(load("res://PressStart2P-vaV7.ttf"))
	return font
