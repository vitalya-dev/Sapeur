extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var mines = 10
export var field_size = 11

var tiles = []
onready var tile_start_position = rect_size / 2 - Vector2(field_size / 2 * 16, field_size / 2 * 16)

signal tile_demine(tile)
signal tile_open(tile)


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	init_tiles()
	distribute_mines(mines)

func init_tiles():
	for y in range(0, field_size):
		tiles.append([])
		for x in range(0, field_size):
			var tile = create_tile(x, y)
			add_child(tile)
			tiles[tile.y].append(tile)
			tile.connect("lmb", self, "_on_tile_lmb")
			tile.connect("rmb", self, "_on_tile_rmb")

func get_neighbors(tile):
	var neighbors_pos_1 = []
	if tile.y % 2 == 1:
		neighbors_pos_1 = [Vector2(tile.x-1, tile.y), Vector2(tile.x, tile.y-1), Vector2(tile.x+1, tile.y-1),
						   Vector2(tile.x+1, tile.y), Vector2(tile.x+1, tile.y+1), Vector2(tile.x, tile.y+1)]
	else:
		neighbors_pos_1 = [Vector2(tile.x-1, tile.y), Vector2(tile.x-1, tile.y-1), Vector2(tile.x, tile.y-1),
						   Vector2(tile.x+1, tile.y), Vector2(tile.x, tile.y+1), Vector2(tile.x-1, tile.y+1)]
	############################################################################################################
	var neighbors_pos_2 = []
	for neighbor_pos in neighbors_pos_1:
		if neighbor_pos.x < 0 or neighbor_pos.x >= field_size:
			continue
		if neighbor_pos.y < 0 or neighbor_pos.y >= field_size:
			continue
		neighbors_pos_2.append(neighbor_pos)
	############################################################################################################
	var neighbors = []
	for neighbor_pos in neighbors_pos_2:
		neighbors.append(tiles[neighbor_pos.y][neighbor_pos.x])
	return neighbors
				
func create_tile(x, y):
	var tile = preload('res://Scenes/HexTile.tscn').instance()
	tile.x = x
	tile.y = y
	tile.centered = true
	tile.position = rect_size / 2 - Vector2(field_size / 2 * 16, field_size / 2 * 16) + Vector2(x * 16 + y % 2 * 8, y * 16)
	return tile
				

func distribute_mines(mines_count):
	randomize()
	while mines_count > 0:
		var x = randi() % field_size
		var y = randi() % field_size
		var tile = tiles[y][x]
		if not tile.mine:
			tile.mine = true
			mines_count -= 1
			for neighbor in get_neighbors(tile):
				neighbor.mines_around += 1

func close_all_execept_mines():
	for tile_row in tiles:
		for tile in tile_row:
			if tile.is_open and !tile.mine:
				tile.close()


func reset_all_tiles_except_demined():
	for tile_row in tiles:
		for tile in tile_row:
			if !(tile.is_open and tile.mine):
				tile.reset()

func no_more_closed_mines():
	for tile_row in tiles:
		for tile in tile_row:
			if !tile.is_open and tile.mine:
				return false
	return true

func open_one_empty_tile():
	randomize()
	while true:
		var x = randi() % field_size
		var y = randi() % field_size
		var tile = tiles[y][x]
		if !tile.is_open and !tile.mine and !tile.mines_around:
			_on_tile_lmb(tile)
			break


func _on_tile_lmb(tile):
	if not tile.is_open:
		tile.open()
		emit_signal("tile_open", tile)
		if tile.mines_around == 0 and not tile.mine:
			for neighbor in get_neighbors(tile):
				_on_tile_lmb(neighbor)


func _on_tile_rmb(tile):
	if not tile.is_open:
		tile.demine()
		emit_signal("tile_demine", tile)


func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
