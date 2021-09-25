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

signal lmb(tile)
signal rmb(tile)

var is_hover = false

var mine = false

var state = "NORMAL";

const text_color = [
	Color("0000ff"),
	Color("008000"),
	Color("ff0000"),
	Color("000080"),
	Color("800000"),
	Color("008080"),
	Color("000000"),
	Color("808080")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Text.text = "%d\n%d" % [x, y]
	$Area2D.connect("mouse_entered", self, "on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "on_mouse_exited")

func _input(ev):
	if is_hover and ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.pressed:
			emit_signal("lmb", self)
		if ev.button_index == 2 and ev.pressed:
			emit_signal("rmb", self)


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


func on_mouse_entered():
	is_hover = true

func on_mouse_exited():
	is_hover = false

func open():
	state = "OPEN"
	if self.mine:
		$Text.set_text("X")
	elif mines_around() > 0:
		$Text.set_text(str(mines_around()))
		$Text.set("custom_colors/font_color", text_color[mines_around() - 1])
	else:
		$Text.set_text("")
	add_to_group("open_tiles")
	set_texture(preload("res://hextile_open.png"))
	
func mines_around():
	var mines = 0
	for neighbor in neighbors:
		if neighbor and neighbor.mine:
			mines += 1
	return mines


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass






