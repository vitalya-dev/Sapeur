extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var start_position = position

var grains : Array
export var grains_count = 20

var shine_period = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	init_grains()

func init_grains():
	var screen_size = get_viewport_rect().size 
	var grains_polygon = $GrainsPolygon.get_polygon()
	for i in range(grains_count): 
		var grain_pos_x = rand_range(-screen_size.x / 2, screen_size.x / 2)
		var grain_pos_y = rand_range(-screen_size.y / 2, screen_size.y / 2)
		var grain_pos = Vector2(grain_pos_x, grain_pos_y)
		if Geometry.is_point_in_polygon(grain_pos, grains_polygon):
			grains.append([grain_pos, Color("#ef9b0f")])


func show_explosion():
	play("Explosion")

func show_glory():
	play("Glory")

func show_normal():
	play("Normal")

func shining():
	$Sun.play("Shine")
	while $Sun.get_animation() == "Shine":
		yield(get_tree().create_timer(shine_period), "timeout")
		update()

func stop_shining():
	$Sun.play("Hide")

func _process(delta):
	var offset = position - get_viewport().get_mouse_position()
	position = lerp(position, position + offset, 0.1)
	position.x = clamp(position.x, start_position.x - 5, start_position.x + 5)
	position.y = clamp(position.y, start_position.y - 5, start_position.y + 5) 


func _draw():
	if $Sun.get_animation() == "Shine":
		for i in range(len(grains)):
			draw_rect(Rect2(grains[i][0], Vector2(1, 1)), grains[i][1].lightened(rand_range(0, 1)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
