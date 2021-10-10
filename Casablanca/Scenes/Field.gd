extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _tiles = []

export var mines = 10
export var field_size = 11

signal tile_open(tile)
signal tile_demine(tile)


# Called when the node enters the scene tree for the first time.
func _ready():
	create_tiles()
	distribute_mines(mines) 

func create_tiles():
	for y in range(0, field_size * 2):
		_tiles.append([])
		for x in range(0, field_size):
			var tile = create_tile(x, y)
			tile.connect("lmb", self, "_on_tile_lmb")
			tile.connect("rmb", self, "_on_tile_rmb")
			add_child(tile)
			_tiles[y].append(tile)

func create_tile(x, y):
	var tile = preload('res://Scenes/Tile.tscn').instance()
	tile.x = x
	tile.y = y
	tile.position = rect_size / 2 - Vector2(field_size / 2 * 32, field_size / 2 * 16) + Vector2(x * 32 + y % 2 * 16, y * 8)
	return tile

func _on_tile_lmb(tile):
	if not tile.is_open:
		tile.open()
		emit_signal("tile_open", tile)
		yield(get_tree().create_timer(0.01), "timeout")
		if tile.mines_around == 0 and not tile.mine:
			for neighbor in get_neighbors(tile):
				_on_tile_lmb(neighbor)
				

func _on_tile_rmb(tile):
	if not tile.is_open:
		tile.demine()
		emit_signal("tile_demine", tile)


func distribute_mines(mines_count):
	randomize()
	while mines_count > 0:
		var x = randi() % field_size
		var y = randi() % (field_size * 2)
		var tile = _tiles[y][x]
		if not tile.mine:
			tile.mine = true
			mines_count -= 1
			for neighbor in get_neighbors(tile):
				neighbor.mines_around += 1

func open_field():
	for tiles_row in _tiles:
		for tile in tiles_row:
			tile.open()
	


func get_neighbors(tile):
	var neighbors_pos_1 = []
	if tile.y % 2 == 1:
		neighbors_pos_1 = [Vector2(tile.x, tile.y-1), Vector2(tile.x, tile.y-2), Vector2(tile.x+1, tile.y-1),
						   Vector2(tile.x+1, tile.y+1), Vector2(tile.x, tile.y+2), Vector2(tile.x, tile.y+1)]
	else:
		neighbors_pos_1 = [Vector2(tile.x-1, tile.y-1), Vector2(tile.x, tile.y-2), Vector2(tile.x, tile.y-1),
						   Vector2(tile.x, tile.y+1), Vector2(tile.x, tile.y+2), Vector2(tile.x-1, tile.y+1)]
	############################################################################################################
	var neighbors_pos_2 = []
	for neighbor_pos in neighbors_pos_1:
		if neighbor_pos.x < 0 or neighbor_pos.x >= field_size:
			continue
		if neighbor_pos.y < 0 or neighbor_pos.y >= field_size * 2:
			continue
		neighbors_pos_2.append(neighbor_pos)
	############################################################################################################
	var neighbors = []
	for neighbor_pos in neighbors_pos_2:
		neighbors.append(_tiles[neighbor_pos.y][neighbor_pos.x])
	return neighbors 




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
