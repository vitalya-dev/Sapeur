extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var messages: PoolStringArray
export var avatar_1: Texture
export var avatar_2: Texture
export var avatar_3: Texture
export var avatar_4: Texture

var current_message = 0


signal showing_current_message(i)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", self, "_on_button_pressed")
	if messages.size() > 0:
		show_current_message()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_message >= messages.size() - 1:
		$Button/ButtonText.text = "Выход"


func _on_button_pressed():
	if $Text.percent_visible < 1:
		$Text.percent_visible = 1
		return
	if current_message >= messages.size() - 1:
		queue_free()
		return
	current_message += 1
	show_current_message()

	
func show_current_message():
	match messages[current_message][0]:
		"@":
			$Avatar/Picture.texture = avatar_1
		"#":
			$Avatar/Picture.texture = avatar_2
		"$":
			$Avatar/Picture.texture = avatar_3
		"%":
			$Avatar/Picture.texture = avatar_4
	############################################################################################################
	$Text.text = messages[current_message].right(1)
	$Text.percent_visible = 0
	############################################################################################################
	yield(get_tree(), "idle_frame")
	############################################################################################################
	emit_signal("showing_current_message", current_message)
	############################################################################################################
	while $Text.percent_visible < 1:
		$Text.visible_characters += 1
		$TypewriterSFX.play()
		yield($TypewriterSFX, "finished")
