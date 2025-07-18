extends CharacterBody3D

@export var speed = 2
@export var jump_speed = 3
@onready var cam : Camera3D = $Camera3D
@onready var looking_at_ray : RayCast3D = $Camera3D/RayCast3D

var gravity = 24.0 #ProjectSettings.get_setting("physics/3d/default_gravity")
var sensitivity = 0.002


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		rotation.y = rotation.y - event.relative.x * sensitivity
		cam.rotation.x = cam.rotation.x - event.relative.y * sensitivity
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-70), deg_to_rad(80))

	
	if Input.is_action_just_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if looking_at_ray.is_colliding():
			print( looking_at_ray.get_collider())
			if looking_at_ray.get_collider().get_parent().has_method("grow_at_pos"):
				looking_at_ray.get_collider().get_parent().grow_at_pos(looking_at_ray.get_collision_point())
	#elif Input.is_action_just_pressed("right_click"):
		#if looking_at_ray.is_colliding():
			#if looking_at_ray.get_collider().has_method("add_block"):
				#var user_block_type = int(get_node(user_block_selection_path).text)
				#user_block_type = clamp(user_block_type, 0, 8)
				#looking_at_ray.get_collider().add_block(looking_at_ray.get_collision_point() \
					#+ looking_at_ray.get_collision_normal() * 0.5, user_block_type)
	elif looking_at_ray.is_colliding():
			if get_parent().has_method("highlight_pos"):
				get_parent().highlight_pos(looking_at_ray.get_collision_point())
					

	
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	


func _on_body_entered_aura(body: Node3D) -> void:
	if body.is_in_group("plant"):
		if body.get_parent().has_method("enter_player_aura"):
			body.get_parent().enter_player_aura()


func _on_body_exited_aura(body: Node3D) -> void:
	if body.is_in_group("plant"):
		if body.get_parent().has_method("exit_player_aura"):
			body.get_parent().exit_player_aura()
