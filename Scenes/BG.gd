extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var stars : Array
export var stars_count = 20
var period = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	init_stars()

func init_stars():
	var sky_polygon = $SkyPolygon.get_polygon()
	for i in range(stars_count):
		var star_pos = Vector2(rand_range(0, 426), rand_range(0, 240))
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
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	update()
