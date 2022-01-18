extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var field_size = Vector2(11, 11)

var _tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	_create_tiles()


func _create_tiles():
	for y in range(0, field_size.y):
		_tiles.append([])
		for x in range(0, field_size.x):
			var tile = _create_tile(x, y)
			tile.connect("lmb", self, "_on_tile_lmb")
			tile.connect("rmb", self, "_on_tile_rmb")
			add_child(tile)
			_tiles[y].append(tile)


func _create_tile(x, y):
	var tile = preload('res://Scenes/Shared/Tile.tscn').instance()
	tile.x = x
	tile.y = y
	tile.position = rect_size / 2 - Vector2(int(field_size.x / 2) * 32 + 8, int(field_size.y / 2) * 8)
	tile.position += Vector2(x * 32 + y % 2 * 16, y * 8)
	return tile


func get_safty_tile():
	randomize()
	var attempt = 0
	while true:
		attempt += 1
		var x = randi() % int(field_size.x)
		var y = randi() % int(field_size.y)
		var tile = _tiles[y][x]
		if !tile.is_open and !tile.mine and tile.mines_around == 0:
			return tile
		if !tile.is_open and !tile.mine and tile.mines_around == 1 and attempt > 100:
			return tile
		if !tile.is_open and !tile.mine and tile.mines_around == 2 and attempt > 200:
			return tile
		if !tile.is_open and !tile.mine and tile.mines_around == 3 and attempt > 300:
			return tile
		if !tile.is_open and !tile.mine and tile.mines_around == 4 and attempt > 400:
			return tile
		if !tile.is_open and !tile.mine and tile.mines_around == 5 and attempt > 500:
			return tile
		if !tile.is_open and !tile.mine and tile.mines_around == 6 and attempt > 600:
			return tile

func _on_tile_lmb(tile):
	if not tile.is_open:
		tile.open()
		Events.push({"owner": "field", "name": "tile_open", "tile": tile})
		############################################################################################################
		if tile.mines_around == 0 and not tile.mine:
			for neighbor in _get_neighbors(tile):
				_on_tile_lmb(neighbor)

func _on_tile_rmb(tile):
	if tile.is_flagged():
		tile.unflag()
		Events.push({"owner": "field", "name": "tile_unflag", "tile": tile})
	elif not tile.is_open:
		tile.flag()
		Events.push({"owner": "field", "name": "tile_flag", "tile": tile})


func solved():
	for tiles_row in _tiles:
		for tile in tiles_row:
			if tile.mine and !tile.is_flagged():
				return false
			if !tile.mine and !tile.is_open:
				return false
	return true


func distribute_mines(mines_count):
	randomize()
	while mines_count > 0:
		var x = randi() % int(field_size.x)
		var y = randi() % int(field_size.y)
		var tile = _tiles[y][x]
		if not tile.mine:
			tile.mine = true
			mines_count -= 1
			for neighbor in _get_neighbors(tile):
				neighbor.mines_around += 1


func open_field():
	for tiles_row in _tiles:
		for tile in tiles_row:
			if not tile.is_open:
				tile.open()

func text_visible(value):
	for tiles_row in _tiles:
		for tile in tiles_row:
			tile.text_visible(value)
	
func reset():
	for tiles_row in _tiles:
		for tile in tiles_row:
			tile.reset()
	

func _get_neighbors(tile):
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
		if neighbor_pos.x < 0 or neighbor_pos.x >= field_size.x:
			continue
		if neighbor_pos.y < 0 or neighbor_pos.y >= field_size.y:
			continue
		neighbors_pos_2.append(neighbor_pos)
	############################################################################################################
	var neighbors = []
	for neighbor_pos in neighbors_pos_2:
		neighbors.append(_tiles[neighbor_pos.y][neighbor_pos.x])
	return neighbors



