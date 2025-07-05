extends Camera2D


@export var sensitivity = 1
var mouse_move_cam = true

@export var tilemap_path : NodePath = "../TileMapLayer"
@onready var tilemap : TileMapLayer = get_node(tilemap_path)

const SWIPE_LENGTH = 50
var swipe_start_pos : Vector2
var swipe_curr_pos : Vector2
var swipe = false

const CAM_POS_MIN = Vector2(-1000,-1000)
const CAM_POS_MAX = Vector2(1000,1000)

const GROW_RANGE = 1
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_move_cam = false
	
	if mouse_move_cam and event is InputEventMouseMotion:
		position = position + event.relative * sensitivity
	
	#if Input.is_action_just_pressed("jump"):
		#grow_plants_in_cam()
		
	if  !swipe && (Input.is_action_just_pressed("mobile_press") || event is InputEventScreenTouch):
		swipe = true
		swipe_start_pos = get_global_mouse_position()
		print("Start swipe=", swipe_start_pos)
	elif swipe && (Input.is_action_pressed("mobile_press") || event is InputEventScreenTouch):
		swipe_curr_pos = get_global_mouse_position()
		if swipe_start_pos.distance_to(swipe_curr_pos) > SWIPE_LENGTH:
			swipe = false
	else:
		swipe = false

func grow_plants_in_cam():
	var cam_pos = position
	var map_cood = tilemap.local_to_map(cam_pos)
	for x in range(map_cood.x - GROW_RANGE, map_cood.x + GROW_RANGE):
		for y in range(map_cood.y - GROW_RANGE, map_cood.y + GROW_RANGE):
			tilemap.grow_tile_cood(Vector2i(x, y), 1)


func _on_grow_timer_timeout() -> void:
	grow_plants_in_cam()
