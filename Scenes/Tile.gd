extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mine = false 
var mines_around = 0

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
	
signal lmb(tile)
signal rmb(tile)

var state = "NORMAL";

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("tiles")

func _input(ev):
	if is_hovered() and ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.pressed:
			emit_signal("lmb", self)
		if ev.button_index == 2 and ev.pressed:
			emit_signal("rmb", self)

func flag():
	$Image.set_texture(preload("res://Assets/flag.png"))
	state = "FLAGGED"
	add_to_group("flagged")
	set_texture(preload("res://Assets/tile_normal.png"))
	$FlagSFX.play()


func unflag():
	$Image.set_texture(null)
	state = "NORMAL"
	remove_from_group("flagged")
	set_texture(preload("res://Assets/tile_normal.png"))
	if not $FlagSFX.is_playing():
		$FlagSFX.play()
								
func open():
	state = "OPEN"
	if self.mine:
		$Text.set_text("X")
	elif mines_around > 0:
		$Text.set_text(str(mines_around))
		$Text.set("custom_colors/font_color", text_color[mines_around - 1])
	else:
		$Text.set_text("")
	add_to_group("open")
	set_texture(preload("res://Assets/tile_open.png"))
	if not $OpenSFX.is_playing():
		$OpenSFX.play()
		print("play")
	
func set_texture(texture):
	set_normal_texture(texture)
	set_hover_texture(texture)
	set_pressed_texture(texture)
	set_focused_texture(texture)	
		
