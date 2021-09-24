extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tiles = []

onready var tile_start_position = rect_size / 2 - Vector2(5 * 16, 5 * 16)


# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(0, 11):
		tiles.append([])
		for x in range(0, 11):
			var tile = create_tile(x, y)
			add_tile(tile)
			set_neighbors(tile)
	connect_neighbors()

func connect_neighbors():
	for tile_row in tiles:
		for tile in tile_row:
			tile.connect_neighbors()

func set_neighbors(tile):
	if tile.x > 0:
		tile.neighbors[tile.HexDirection.W] = tiles[tile.y][tile.x-1]
	if tile.y > 0:
		if tile.y % 2 == 1:
			tile.neighbors[tile.HexDirection.NW] = tiles[tile.y - 1][tile.x]
			if tile.x < len(tiles[tile.y - 1]) - 1:
				tile.neighbors[tile.HexDirection.NE] = tiles[tile.y - 1][tile.x + 1]
		else:
			tile.neighbors[tile.HexDirection.NE] = tiles[tile.y - 1][tile.x]
			if tile.x > 0:
				tile.neighbors[tile.HexDirection.NW] = tiles[tile.y - 1][tile.x - 1]

func add_tile(tile):
	add_child(tile)
	tiles[tile.y].append(tile)

			
func create_tile(x, y):
	var tile = preload('res://HexTile.tscn').instance()
	tile.x = x
	tile.y = y
	tile.centered = true
	tile.position = tile_start_position + Vector2(x * 16 + y % 2 * 8, y * 16)
	return tile
				


func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
