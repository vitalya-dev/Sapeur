extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _tiles = []

export var field_size = 11


# Called when the node enters the scene tree for the first time.
func _ready():
	create_tiles()

func create_tiles():
	for y in range(0, field_size * 2):
		_tiles.append([])
		for x in range(0, field_size):
			var tile = create_tile(x, y)
			add_child(tile)
			_tiles[y].append(tile)

func create_tile(x, y):
	var tile = preload('res://Scenes/Tile.tscn').instance()
	tile.position = rect_size / 2 - Vector2(field_size / 2 * 32, field_size / 2 * 16) + Vector2(x * 32 + y % 2 * 16, y * 8)
	return tile


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
