extends CharacterBody3D

@export var speed = 10
@export var jump_velocity = 4.5

var look_sens = ProjectSettings.get_setting("player/look_sensitivity")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity_y = 0
var is_in_menu = false
var sprint_factor = 2

@onready var camera:Camera3D = $Camera3D

func _physics_process(delta):
	
		
	#WASD Movement
	var horizontal_velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").normalized()
	
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	##handle sprinting 
	#if Input.is_action_pressed("sprint"):
		#velocity.x = velocity.x * sprint_factor
		
	if is_on_floor():
		velocity_y = 0
		if Input.is_action_just_pressed("jump"): velocity_y = jump_velocity
	else:
		velocity_y -= gravity * delta
	velocity.y = velocity_y	
	move_and_slide()
	
	#ui_cancel esc by default frees mouse when pressing escape FIX: mouse is still moving camera on esc
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _input(event):
	if event is InputEventMouseMotion and Input.MOUSE_MODE_HIDDEN:
		rotate_y(-event.relative.x * look_sens)
		camera.rotate_x(-event.relative.y * look_sens)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
