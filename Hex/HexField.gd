extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var mines = 10
export var field_size = 11

var tiles = []
onready var tile_start_position = rect_size / 2 - Vector2(5 * 16, 5 * 16)


# Called when the node enters the scene tree for the first time.
func _ready():
	init_tiles()
	distribute_mines()

func init_tiles():
	for y in range(0, field_size):
		tiles.append([])
		for x in range(0, field_size):
			var tile = create_tile(x, y)
			add_child(tile)
			tiles[tile.y].append(tile)
			tile.connect("lmb", self, "_on_tile_lmb")

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
	var tile = preload('res://HexTile.tscn').instance()
	tile.x = x
	tile.y = y
	tile.centered = true
	tile.position = tile_start_position + Vector2(x * 16 + y % 2 * 8, y * 16)
	return tile
				

func distribute_mines():
	randomize()
	var mines_count = mines
	while mines_count > 0:
		var x = randi() % field_size
		var y = randi() % field_size
		var tile = tiles[y][x]
		if not tile.mine:
			tile.mine = true
			mines_count -= 1
			for neighbor in get_neighbors(tile):
				neighbor.mines_around += 1

func _on_tile_lmb(tile):
	match tile.state:
		"NORMAL":
			tile.open()
			if tile.mines_around == 0 and not tile.mine:
				for neighbor in get_neighbors(tile):
					_on_tile_lmb(neighbor)



func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
