extends Node

# Puck Variables
@export var MOVEMENT_MODE = 2
@export var GRAVITY_MULT = 4
@export var PUCK_MAX_SPEED = 30

# Movement Variables
var mouse_click_pos = 0
var mouse_release_pos = 0
var mouse_go = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".gravity_scale = GRAVITY_MULT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MOVEMENT_MODE == 0:
		move_static(delta)
	elif MOVEMENT_MODE == 1:
		move_dynamic(delta)
	else:
		move_manual(delta)
	pass


# Parse keyboard input
func _input(event):
	
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_click_pos = event.position
		elif event.is_released:
			mouse_release_pos = event.position
			mouse_go = 1
	
	if Input.is_physical_key_pressed(KEY_A) || Input.is_physical_key_pressed(KEY_D) || Input.is_physical_key_pressed(KEY_W) || Input.is_physical_key_pressed(KEY_S):
		MOVEMENT_MODE = 2
	if Input.is_physical_key_pressed(KEY_SPACE):
		MOVEMENT_MODE = 1
	
	# Reset ball on "R" press
	if Input.is_physical_key_pressed(KEY_R):
		reset_puck()


func move_manual(delta):
	if mouse_go == 1:
		mouse_go = 0
		
		# Added force
		var raw_force_vector = mouse_release_pos - mouse_click_pos
		var raw_force_angle = atan2(raw_force_vector.y, raw_force_vector.x)
		var raw_force_velocity_magnitude = sqrt(pow(raw_force_vector.x, 2) + pow(raw_force_vector.y, 2))
		
		var adjusted_force_angle = raw_force_angle - $"../Camera3D".rotation.y
		var adjusted_force_z = raw_force_velocity_magnitude * sin(adjusted_force_angle)
		var adjusted_force_x = raw_force_velocity_magnitude * cos(adjusted_force_angle)
		
		$".".linear_velocity.x += adjusted_force_x * delta * 3
		$".".linear_velocity.z += adjusted_force_z * delta * 3


func move_dynamic(delta):
	if mouse_go == 1:
		mouse_go = 0
		
		# Added force
		var raw_force_vector = mouse_release_pos - mouse_click_pos
		var raw_force_angle = atan2(raw_force_vector.y, raw_force_vector.x)
		var raw_force_velocity_magnitude = sqrt(pow(raw_force_vector.x, 2) + pow(raw_force_vector.y, 2))
		
		# Existing direction
		var puck_velocity_vector = $".".linear_velocity
		var puck_velocity_angle = atan2(puck_velocity_vector.z, puck_velocity_vector.x)
		var puck_velocity_magnitude = sqrt(pow(puck_velocity_vector.x, 2) + pow(puck_velocity_vector.z, 2))
		
		# Alter added force to account for camera position\
		var final_force_angle = raw_force_angle + puck_velocity_angle + deg_to_rad(180)
		var final_force_x = raw_force_velocity_magnitude * sin(final_force_angle)
		var final_force_z = raw_force_velocity_magnitude * cos(final_force_angle)
		
		$".".linear_velocity.x += final_force_x * delta * 5
		$".".linear_velocity.z -= final_force_z * delta * 5


func move_static(delta):
	if mouse_go == 1:
		mouse_go = 0
		var change = mouse_release_pos - mouse_click_pos
		
		$".".linear_velocity.x += change.x * delta * 3
		$".".linear_velocity.x = PUCK_MAX_SPEED if $".".linear_velocity.x > PUCK_MAX_SPEED else $".".linear_velocity.x
		$".".linear_velocity.x = -1*PUCK_MAX_SPEED if $".".linear_velocity.x < -1*PUCK_MAX_SPEED else $".".linear_velocity.x
		
		$".".linear_velocity.z += change.y * delta * 3
		$".".linear_velocity.z = PUCK_MAX_SPEED if $".".linear_velocity.z > PUCK_MAX_SPEED else $".".linear_velocity.z
		$".".linear_velocity.z = -1*PUCK_MAX_SPEED if $".".linear_velocity.z < -1*PUCK_MAX_SPEED else $".".linear_velocity.z


func reset_puck():
	$".".linear_velocity = Vector3(0,0,0)
	$".".position = Vector3(0,1,0)
	$".".angular_velocity = Vector3(0,0,0)
