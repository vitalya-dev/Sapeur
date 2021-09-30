extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var x = 0
var y = 0

signal lmb(tile)
signal rmb(tile)

var is_hover = false

var _mine = false 
var mines_around = 0 setget mines_around_setter

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
	add_to_group("normal_tiles")


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
	remove_from_group("normal_tiles")
	adapt()
	
func mine():
	self._mine = true
	state = "NORMAL"
	adapt()

func demine():
	state = "DEMINED"
	remove_from_group("normal_tiles")
	adapt()

func mines_around_setter(value):
	mines_around = value
	adapt()


func adapt():
	match state:
		"OPEN":
			if self._mine:
				$Text.set_text("")
				$Image.set_texture(preload("res://Assets/Graphics/mine.png"))
			elif mines_around > 0:
				$Text.set_text(str(mines_around))
				$Text.set("custom_colors/font_color", text_color[mines_around - 1])
			else:
				$Text.set_text("")
			set_texture(preload("res://Assets/Graphics/hextile_open.png"))
		"NORMAL":
			$Text.set_text("")
			set_texture(preload("res://Assets/Graphics/hextile_normal.png"))
		"DEMINED":
			if self._mine:
				$Image.set_texture(preload("res://Assets/Graphics/demine.png"))
			else:
				$Text.set_text("X")
				$Text.set("custom_colors/font_color", Color.white)
				set_texture(preload("res://Assets/Graphics/hextile_open.png"))

func is_mined():
	return self._mine


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass






