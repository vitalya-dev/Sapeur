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
    
signal open
signal flagged

var state = "NORMAL";


# Called when the node enters the scene tree for the first time.
func _ready():
    add_to_group("tiles")

func _input(ev):
    if is_hovered() and ev is InputEventMouseButton:
        if ev.button_index == 2 and ev.pressed:
            flag()
        if ev.button_index == 1 and ev.pressed:
            open()

func flag():
    match state:
        "NORMAL":
            $Text.set_text("F")
            state = "FLAGGED"
            emit_signal("flagged")
        "FLAGGED":
            $Text.set_text("")
            state = "NORMAL"
                                
func open():
    match state:
        "FLAGGED", "NORMAL":
            state = "OPEN"
            if self.mine:
                $Text.set_text("X")
            elif mines_around > 0:
                $Text.set_text(str(mines_around))
                $Text.set("custom_colors/font_color", text_color[mines_around - 1])
            else:
                $Text.set_text("")
            set_texture(preload("res://Assets/tile_open.png"))
            emit_signal("open")
    
func set_texture(texture):
    set_normal_texture(texture)
    set_hover_texture(texture)
    set_pressed_texture(texture)
    set_focused_texture(texture)	
        

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
