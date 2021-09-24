extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var stars : Array
export var stars_count = 20
var period = 0.3
onready var start_position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	init_stars()

func init_stars():
	var screen_size = get_viewport_rect().size
	var sky_polygon = $SkyPolygon.get_polygon()
	for i in range(stars_count):
		var star_pos = Vector2(rand_range(0, screen_size.x), rand_range(0, screen_size.y))
		if Geometry.is_point_in_polygon(star_pos, sky_polygon):
			var color = Color("#15311d") if rand_range(0, 1) > 0.5 else Color("#89c06f")
			stars.append([star_pos, color])

func start_blinking_routine():
	while true:
		yield(get_tree().create_timer(period), "timeout")
		update()

		
func _draw():
	for i in range(len(stars)):
		draw_circle(stars[i][0], 1, stars[i][1].lightened(rand_range(0, 1)))

func _input(event):
	pass
	# var screen_size = get_viewport_rect().size
	# if event is InputEventMouseMotion:
	# 	var dx = screen_size.x / 2 - event.position.x
	# 	var dy = screen_size.y / 2 - event.position.y
	# 	position.x = lerp(position.x, (1 if dx > 0 else - 1), 0.1)
	# 	print("dx:%s dy:%s" % [dx, dy])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, get_viewport_rect().size / 2 - get_viewport().get_mouse_position(), 0.1)
	position.x = clamp(position.x, start_position.x, -1)
	position.y = clamp(position.y, start_position.y, -1)

