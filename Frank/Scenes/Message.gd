extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var messages: PoolStringArray
export var avatar_1: Texture
export var avatar_2: Texture
export var avatar_3: Texture
export var avatar_4: Texture
export var avatar_5: Texture
export var avatar_6: Texture
export var avatar_7: Texture
export var avatar_8: Texture
export var avatar_9: Texture
export var avatar_10: Texture

var current_message = 0


signal change(current_message)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", self, "_on_button_pressed")
	if messages.size() > 0:
		show_current_message()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	############################################################################################################
	emit_signal("change", current_message)
	############################################################################################################
	show_current_message()

	
func show_current_message():
	if len(messages[current_message]) == 0:
		return
	match messages[current_message][0]:
		"@":
			$Avatar/Picture.texture = avatar_1 #Colonel
		"#":
			$Avatar/Picture.texture = avatar_2 #Sergeant
		"$":
			$Avatar/Picture.texture = avatar_3 #Operator
		"%":
			$Avatar/Picture.texture = avatar_4 #Mom
		"^":
			$Avatar/Picture.texture = avatar_5 #Bomber
		"&":
			$Avatar/Picture.texture = avatar_6 #Brother
		"*":
			$Avatar/Picture.texture = avatar_7 #Doctor
		"(":
			$Avatar/Picture.texture = avatar_8 #Wife
		")":
			$Avatar/Picture.texture = avatar_9 #Ahmed
		"-":	
			$Avatar/Picture.texture = avatar_10 #Ahmed
	############################################################################################################
	$Text.text = messages[current_message].right(1)
	if $Text.text == "":
		return
	$Text.percent_visible = 0
	############################################################################################################
	yield(get_tree(), "idle_frame")
	############################################################################################################
	while $Text.percent_visible < 1:
		$Text.visible_characters += 1
		$TypewriterSFX.play()
		yield($TypewriterSFX, "finished")
