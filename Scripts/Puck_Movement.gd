extends Node

# GLOBALS ------------------------------------------------------------------------------------------
# Puck Variables
@export var MOVEMENT_MODE = 2
@export var GRAVITY_MULT = 5
@export var PUCK_MAX_SPEED = 30
@export var MOVE_MULT = 5

# Applied Movement Variables
var mouse_click_pos = 0
var mouse_release_pos = 0
var apply_movement = 0

# BUILT IN -----------------------------------------------------------------------------------------
# Called when the node enters the scene tree for the first time.
func _ready():
	$".".gravity_scale = GRAVITY_MULT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if apply_movement == 1:
		apply_movement = 0
		
		if MOVEMENT_MODE == 0:
			move_static(delta)
		elif MOVEMENT_MODE == 1:
			move_dynamic(delta)
		else:
			move_manual(delta)
			
		cap_speed()# This is inside bc i like the idea of players using downhill slopes to get above max speed


# Parse keyboard input
func _input(event):
	# Apply movement
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_click_pos = event.position
		elif event.is_released:
			mouse_release_pos = event.position
			apply_movement = 1
	
	# Update movement mode
	if Input.is_physical_key_pressed(KEY_A) || Input.is_physical_key_pressed(KEY_D) || Input.is_physical_key_pressed(KEY_W) || Input.is_physical_key_pressed(KEY_S):
		MOVEMENT_MODE = 2
	if Input.is_physical_key_pressed(KEY_SPACE):
		MOVEMENT_MODE = 1
	
	# Reset ball on "R" press
	if Input.is_physical_key_pressed(KEY_R):
		reset_puck()


# MOVEMENT -----------------------------------------------------------------------------------------
func move_manual(delta):
	# Calculate added force
	var raw_force_vector = mouse_release_pos - mouse_click_pos
	var raw_force_angle = atan2(raw_force_vector.y, raw_force_vector.x)
	var raw_force_velocity_magnitude = sqrt(pow(raw_force_vector.x, 2) + pow(raw_force_vector.y, 2))
	
	# Adjust 
	var adjusted_force_angle = raw_force_angle - $"../Camera3D".rotation.y
	var adjusted_force_z = raw_force_velocity_magnitude * sin(adjusted_force_angle)
	var adjusted_force_x = raw_force_velocity_magnitude * cos(adjusted_force_angle)
	
	# Apply
	$".".linear_velocity.x += adjusted_force_x * delta * MOVE_MULT
	$".".linear_velocity.z += adjusted_force_z * delta * MOVE_MULT


func move_dynamic(delta):
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
	
	# Apply
	$".".linear_velocity.x += final_force_x * delta * MOVE_MULT
	$".".linear_velocity.z -= final_force_z * delta * MOVE_MULT


func move_static(delta):
	var change = mouse_release_pos - mouse_click_pos
	
	$".".linear_velocity.x += change.x * delta * MOVE_MULT
	$".".linear_velocity.x = PUCK_MAX_SPEED if $".".linear_velocity.x > PUCK_MAX_SPEED else $".".linear_velocity.x
	$".".linear_velocity.x = -1*PUCK_MAX_SPEED if $".".linear_velocity.x < -1*PUCK_MAX_SPEED else $".".linear_velocity.x
	
	$".".linear_velocity.z += change.y * delta * MOVE_MULT
	$".".linear_velocity.z = PUCK_MAX_SPEED if $".".linear_velocity.z > PUCK_MAX_SPEED else $".".linear_velocity.z
	$".".linear_velocity.z = -1*PUCK_MAX_SPEED if $".".linear_velocity.z < -1*PUCK_MAX_SPEED else $".".linear_velocity.z


# UTILITY ------------------------------------------------------------------------------------------
func cap_speed():
	var curr_velocity_magnitude = sqrt(pow($".".linear_velocity.x, 2) + pow($".".linear_velocity.z, 2))
	if curr_velocity_magnitude > PUCK_MAX_SPEED:
		var factor = PUCK_MAX_SPEED / curr_velocity_magnitude
		$".".linear_velocity.x = $".".linear_velocity.x * factor
		$".".linear_velocity.z = $".".linear_velocity.z * factor


func reset_puck():
	$".".linear_velocity = Vector3(0,0,0)
	$".".position = Vector3(0,1,0)
	$".".angular_velocity = Vector3(0,0,0)
