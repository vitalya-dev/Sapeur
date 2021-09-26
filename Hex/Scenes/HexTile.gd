extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var x = 0
var y = 0

signal lmb(tile)
signal rmb(tile)

var is_hover = false

var mine = false
var mines_around = 0

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

func on_mouse_entered():
	is_hover = true

func on_mouse_exited():
	is_hover = false

func open():
	state = "OPEN"
	if self.mine:
		$Text.set_text("X")
	elif mines_around > 0:
		$Text.set_text(str(mines_around))
		$Text.set("custom_colors/font_color", text_color[mines_around - 1])
	else:
		$Text.set_text("")
	add_to_group("open_tiles")
	set_texture(preload("res://Assets/Graphics/hextile_open.png"))
	

func flag():
	$Image.set_texture(preload("res://Assets/Graphics/flag.png"))
	state = "FLAGGED"
	add_to_group("flagged_tiles")


func unflag():
	$Image.set_texture(null)
	state = "NORMAL"
	remove_from_group("flagged_tiles")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass






