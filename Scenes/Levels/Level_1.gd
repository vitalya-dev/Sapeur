extends CenterContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    $Field.connect("win", self, "_on_win")
    $Field.connect("fail", self, "_on_fail")
    show_intro_message()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_fail():
    pass # Replace with function body.


func _on_win():
    pass # Replace with function body.


func show_intro_message():
    var message = preload('res://Scenes/Message.tscn').instance()
    message.messages = ["@Это учебное задание.", "@Обезвредь все мины, сержант.", "#Будет исполнено товарищ полковник."]
    message.avatar_1 = preload("res://Assets/avatar_colonel.png")
    message.avatar_2 = preload("res://Assets/avatar_sergeant.png")
    add_child(message);
