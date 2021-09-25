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
	connect_neighbors()
	distribute_mines()

func init_tiles():
	for y in range(0, field_size):
		tiles.append([])
		for x in range(0, field_size):
			var tile = create_tile(x, y)
			add_tile(tile)
			connect_tile(tile)
			set_neighbors(tile)


func connect_tile(tile):
	tile.connect("lmb", self, "_on_tile_lmb")

func connect_neighbors():
	for y in range(0, field_size):
		for x in range(0, field_size):
			tiles[y][x].connect_neighbors()

func set_neighbors(tile):
	if tile.x > 0:
		tile.neighbors[tile.HexDirection.W] = tiles[tile.y][tile.x-1]
	if tile.y > 0:
		if tile.y % 2:
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
				

func distribute_mines():
	randomize()
	var mines_count = mines
	while mines_count > 0:
		var x = randi() % field_size
		var y = randi() % field_size
		if not tiles[y][x].mine:
			tiles[y][x].mine = true
			mines_count -= 1

func _on_tile_lmb(tile):
	match tile.state:
		"NORMAL":
			tile.open()
			if tile.mines_around() == 0 and not tile.mine:
				for neighbor in tile.neighbors:
					if neighbor:
						_on_tile_lmb(neighbor)



func _input(ev):
	if ev.is_action_pressed("ui_cancel"):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
