extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var messages: PoolStringArray
export var avatar: Texture
var current_message = 0
var frame_delta = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Avatar/Picture.texture = avatar
	if messages.size() > 0:
		show_current_message()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frame_delta = delta


func _on_Button_pressed():
	if current_message < messages.size() - 1:
		current_message += 1
		show_current_message()
	else:
		hide()

func show_current_message():
	$Text.text = messages[current_message]
	$Text.percent_visible = 0;		
	while $Text.percent_visible < 1:
		$Text.percent_visible += frame_delta
		yield(get_tree(), "idle_frame")
