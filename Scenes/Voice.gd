extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var voices : Array
var voices_path = "res://Assets/Voices/"

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = Directory.new()
	if dir.open(voices_path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.get_extension() != "import":
				voices.append(load(voices_path.plus_file(file_name)))
			file_name = dir.get_next()

func talk():
		set_stream(voices[randi() % voices.size()])
		play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
