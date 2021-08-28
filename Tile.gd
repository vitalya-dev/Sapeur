extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mine = false 
var mines_around = 0

signal open

enum {
	NORMAL,
	OPEN,
	FLAGGED
}

var state = NORMAL;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(ev):
	if is_hovered() and ev is InputEventMouseButton:
		if ev.button_index == 2 and ev.pressed:
			flag()
		if ev.button_index == 1 and ev.pressed:
			open()

func flag():
	match state:
		NORMAL:
			set_text("F")
			state = FLAGGED
		FLAGGED:
			set_text("")
			state = NORMAL
								
func open():
	match state:
		FLAGGED, NORMAL:
			state = OPEN
			if self.mine:
				set_text("X")
			else:
				set_text(str(mines_around))
			emit_signal("open")
	
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(flagged)
