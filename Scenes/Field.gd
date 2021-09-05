extends Control

export var size : Vector2
export var mines : int

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


signal win
signal fail

var state = "INIT"
var debug_font = make_font(24)

# Called when the node enters the scene tree for the first time.
func init():
    $Panel.rect_size = Vector2(0, 0)
    make_tiles()
    distribute_mines()
    set_neighbors()
    #adjust_window_size();
    switch_full_screen();


func make_font(font_size):
    var font = DynamicFont.new()
    font.size = font_size
    font.set_font_data(load("res://PressStart2P-vaV7.ttf"))
    return font

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    match state:
        "INIT":
            init()
            state = "GAME"
        "GAME":
            pass
        "WIN":
            pass
        "FAIL":
            pass


func _draw():
    #draw_string(debug_font, Vector2(0, 24), state, Color(1.0, 1.0, 1.0))
    pass
    

func _input(ev):
    if ev.is_action_pressed("ui_cancel"):
        get_tree().quit()

func make_tiles():
    $Panel/Grid.set_columns(size.x)
    for y in range(size.y):
        for x in range(size.x):
            var tile = preload('res://Scenes/Tile.tscn').instance()
            tile.connect("open", self, '_on_tile_open', [Vector2(x, y)])
            tile.connect("flagged", self, "_on_tile_flagged", [Vector2(x, y)])
            $Panel/Grid.add_child(tile);
            
func distribute_mines():
    randomize()
    var mines_count = mines
    while mines_count > 0:
        var minepos = randi() % int(size.x * size.y)
        if not $Panel/Grid.get_child(minepos).mine:
            $Panel/Grid.get_child(minepos).mine = true
            mines_count -= 1	

func set_neighbors():
    for y in range(size.y):
        for x in range(size.x):
            var mines_around = 0
            var pos = Vector2(x, y)
            for neighbor in get_neighbors(pos):
                if get_tile(neighbor).mine:
                    mines_around += 1
            get_tile(pos).mines_around = mines_around

func get_tile(pos):
    return $Panel/Grid.get_child(pos.x + (pos.y * size.x))

func get_neighbors(pos):
    var neighbors = []
    for delta_x in [-1, 0, 1]:
        for delta_y in [-1, 0, 1]:
            var neighbor = Vector2(pos.x + delta_x, pos.y + delta_y)
            if neighbor.x < 0 or neighbor.x >= size.x:
                continue
            if neighbor.y < 0 or neighbor.y >= size.y:
                continue
            if neighbor.x == pos.x and neighbor.y == pos.y:
                continue
            neighbors.append(neighbor)
    return neighbors;
                
func adjust_window_size():
    yield(get_tree(), "idle_frame")
    OS.set_window_size($Panel.rect_size)
    
    
func switch_full_screen():
    yield(get_tree(), "idle_frame")
    OS.window_fullscreen = true

func _on_tile_open(pos):
    if check_fail():
        state = "FAIL"
        get_tree().call_group("tiles", "active", false)
        emit_signal("fail")
    elif check_win():
        state = "WIN"
        get_tree().call_group("tiles", "active", false)
        emit_signal("win")
    elif get_tile(pos).mines_around == 0:
        for neighbor in get_neighbors(pos):
            get_tile(neighbor).open()

func _on_tile_flagged(pos):
    if check_win():
        state = "WIN"
        get_tree().call_group("tiles", "active", false)
        emit_signal("win")


func check_fail():
    for y in range(size.y):
        for x in range(size.x):
            var pos = Vector2(x, y)
            if get_tile(pos).state == "OPEN" and get_tile(pos).mine:
                return true
    return false

func check_win():
    var opened_tiles = 0
    var flagged_tiles = 0
    for y in range(size.y):
        for x in range(size.x):
            var pos = Vector2(x, y)
            if get_tile(pos).state == "OPEN":
                opened_tiles += 1
            elif get_tile(pos).state == "FLAGGED":
                flagged_tiles += 1
    return opened_tiles == size.x * size.y - mines and flagged_tiles == mines
