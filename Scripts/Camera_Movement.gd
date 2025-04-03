extends Node

# Camera movement (0 = fixed, 1 = dynamic, 2=manual)
@export var CAMERA_MODE = 2

# Camera positioning
var HORZ_DISTANCE = 10
var VERT_DISTANCE = 10
var PITCH = deg_to_rad(-45)

# Called when the node enters the scene tree for the first time.
func _ready():
	move_static()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CAMERA_MODE == 0:
		move_static()
	elif CAMERA_MODE == 1:
		move_dynamic()
	else:
		move_manual()


func _input(event):
	# Reset ball on "R" press
	if Input.is_physical_key_pressed(KEY_R):
		reset_camera()
	if Input.is_physical_key_pressed(KEY_A) || Input.is_physical_key_pressed(KEY_D) || Input.is_physical_key_pressed(KEY_W) || Input.is_physical_key_pressed(KEY_S):
		CAMERA_MODE = 2
	if Input.is_physical_key_pressed(KEY_SPACE):
		CAMERA_MODE = 1


func set_position(x, y, z):
	$".".position.x = x
	$".".position.y = y
	$".".position.z = z


func set_position_from_puck(x, y, z):
	$".".position.x = $"../Ball".position.x + x
	$".".position.y = $"../Ball".position.y + y
	$".".position.z = $"../Ball".position.z + z


func set_rotation(x, y, z):
	$".".rotation.x = x
	$".".rotation.y = y
	$".".rotation.z = z


# Sets camera to fix offset from puck, and sets angle to fixed "looking down" angle
func move_static():
	set_position($"../Ball".position.x, $"../Ball".position.y + VERT_DISTANCE, $"../Ball".position.z + HORZ_DISTANCE)
	set_rotation(PITCH, $".".rotation.y, $".".rotation.z)


# Camera dynamically swivels around puck based on puck velocity
func move_dynamic():
	# Set position
	var raw_direction = $"../Ball".linear_velocity
	if ($"../Ball".linear_velocity.x == 0 && $"../Ball".linear_velocity.z == 0):
		return
	var raw_angle = atan2(raw_direction.z, raw_direction.x)
	
	var camera_z_offset = HORZ_DISTANCE * sin(raw_angle)
	var camera_x_offset = HORZ_DISTANCE * cos(raw_angle)
	set_position_from_puck(-1 * camera_x_offset, VERT_DISTANCE, -1 * camera_z_offset)
	
	# Set rotation
	# x = pitch
	# y = left/right
	var camera_angle = atan2(-1*raw_direction.z, raw_direction.x)
	set_rotation(PITCH, deg_to_rad(-90) + camera_angle, $".".rotation.z)
	
	pass

func move_manual():
	#set_position($"../Ball".position.x, $"../Ball".position.y + VERT_DISTANCE, $"../Ball".position.z + HORZ_DISTANCE)
	# Code to manually swivel around ball
	var angle_change = 0
	if Input.is_physical_key_pressed(KEY_A):
		angle_change = deg_to_rad(-2)
	if Input.is_physical_key_pressed(KEY_D):
		angle_change = deg_to_rad(2)
	if Input.is_physical_key_pressed(KEY_W):
		PITCH += deg_to_rad(1)
	if Input.is_physical_key_pressed(KEY_S):
		PITCH -= deg_to_rad(1)
	
	place_around_point($"../Ball".position, $".".rotation.y - angle_change, HORZ_DISTANCE)
	face_to_point($"../Ball".position)


func place_around_point(point, angle, distance):
	var camera_x_offset = distance * sin(angle)
	var camera_z_offset = distance * cos(angle)
	set_position_from_puck(camera_x_offset, VERT_DISTANCE, camera_z_offset)


func face_to_point(point):
	var raw_direction = point - $".".position
	var camera_angle = atan2(-1*raw_direction.z, raw_direction.x)
	set_rotation(PITCH, deg_to_rad(-90) + camera_angle, $".".rotation.z)
# Func that takes in radians and puts the camera facing that angle on unit circle of size HORZ
# Func that takes in position and points camera to position (x and y)

func reset_camera():
	PITCH = deg_to_rad(-45)
	place_around_point($"../Ball".position, deg_to_rad(-0), HORZ_DISTANCE)
	face_to_point($"../Ball".position)
