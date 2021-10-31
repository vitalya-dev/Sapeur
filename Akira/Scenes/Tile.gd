extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_hover = false

var mines_around = 0

var mine = false

var is_open = false 


var x = -1
var y = -1

const text_color = [
	Color("003f88"),
	Color("ff7900"),
	Color("003f88"),
	Color("000080"),
	Color("800000"),
	Color("004e89"),
	Color("000000"),
	Color("808080"),
]

signal lmb(tile)
signal rmb(tile)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("mouse_entered", self, "_on_mouse_entered")
	$Area2D.connect("mouse_exited", self, "_on_mouse_exited")
	play("Close")

func _input(ev):
	if is_hover and ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.pressed:
			emit_signal("lmb", self)
		if ev.button_index == 2 and ev.pressed:
			emit_signal("rmb", self) 

func reset():
	self.frame = 0
	self.is_open = false
	self.mine = false
	self.mines_around = 0
	$Text.set_text("")
	$Image.set_texture(null)
	play("Close")



func open():
	assert(is_open == false, "Tile: open on open tile");
	is_open = true
	play("Open")
	yield(self, "animation_finished")
	if self.mine:
		$Text.set_text("")
		$Image.set_texture(preload("res://Assets/Graphics/mine.png"))
	elif mines_around > 0:
		$Text.set_text(str(mines_around))
		$Text.set("custom_colors/font_color", text_color[mines_around-1])
	else:
		$Text.set_text("")

func close():
	assert(is_open == true, "Tile: close an closed tile")
	is_open = false
	play("Close")
	yield(self, "animation_finished")
	$Text.set_text("")
	$Image.set_texture(null)



func demine():
	assert(is_open == false, "Tile: demine on open tile")
	is_open = true
	if self.mine:
		$Image.set_texture(preload("res://Assets/Graphics/demine.png"))
	else:
		play("Open")
		yield(self, "animation_finished")
		$Text.set_text("X")
		$Text.set("custom_colors/font_color", text_color[mines_around-1] if mines_around > 0 else 0)


func hide_text():
	$Text.visible = false

func show_text():
	$Text.visible = true


func _on_mouse_entered():
	is_hover = true

func _on_mouse_exited():
	is_hover = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
