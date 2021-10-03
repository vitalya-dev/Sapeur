extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var x = 0
var y = 0

signal lmb(tile)
signal rmb(tile)

var is_hover = false

var mines_around = 0

var mine = false
var is_open = false

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
	$Area2D.connect("mouse_entered", self, "on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "on_mouse_exited")


func _input(ev):
	if is_hover and ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.pressed:
			emit_signal("lmb", self)
		if ev.button_index == 2 and ev.pressed:
			emit_signal("rmb", self)

func on_mouse_entered():
	is_hover = true

func on_mouse_exited():
	is_hover = false

func open():
	assert(is_open == false, "HexTile: open on open tile");
	if self.mine:
		$Text.set_text("")
		$Image.set_texture(preload("res://Assets/Graphics/mine.png"))
	elif mines_around > 0:
		$Text.set_text(str(mines_around))
		$Text.set("custom_colors/font_color", text_color[mines_around - 1])
	else:
		$Text.set_text("")
	is_open = true
	set_texture(preload("res://Assets/Graphics/hextile_open.png"))
	

func close():
	assert(is_open == true, "HexTile: close an closed tile");
	$Text.set_text("")
	$Image.set_texture(null)
	is_open = false
	set_texture(preload("res://Assets/Graphics/hextile_normal.png"))


func demine():
	assert(is_open == false, "HexTile: demine on open tile");
	if self.mine:
		$Image.set_texture(preload("res://Assets/Graphics/demine.png"))
	else:
		$Text.set_text("X")
		$Text.set("custom_colors/font_color", Color.white)
		set_texture(preload("res://Assets/Graphics/hextile_open.png"))
	is_open = true

func reset():
	is_open = false
	mine = false
	$Text.set_text("")
	$Image.set_texture(null)
	set_texture(preload("res://Assets/Graphics/hextile_normal.png"))
	





