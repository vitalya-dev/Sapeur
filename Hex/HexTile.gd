extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum HexDirection {
	NE = 0, E, SE, SW, W, NW
}

var neighbors = [null, null, null, null, null, null]
var x = 0
var y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Text.text = "%d\n%d" % [x, y]

func connect_neighbors():
	for direction in range(len(neighbors)):
		var neighbor = neighbors[direction]
		if neighbor:
			neighbor.neighbors[get_opposite_direction(direction)] = self

func get_opposite_direction(direction):
	match direction:
		HexDirection.NE:
			return HexDirection.SW
		HexDirection.E:
			return HexDirection.W
		HexDirection.SE:
			return HexDirection.NW
		HexDirection.SW:
			return HexDirection.NE
		HexDirection.W:
			return HexDirection.E
		HexDirection.NW:
			return HexDirection.SE


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
