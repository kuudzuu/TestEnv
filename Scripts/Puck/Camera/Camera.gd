extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Camera Movement Mode
enum CAMERA_MODE_ENUM {SURROUND, SPRINT, LEASHED}
## SURROUND: Rotates around puck, facing puck ///
## SPRINT: Rotates in place, and moves across map towards cursor ///
## FLOAT: Fixed at continuous xz offset from puck, rotates in place ///
## LEASHED: Attached "behind" puck "looking forwards" (velocity determines direction) ///
var CAMERA_MODE: CAMERA_MODE_ENUM

## Defaults
var DEFAULT_DISTANCE = 10
var DEFAULT_HEIGHT = 35
var DEFAULT_GRADE = deg_to_rad(-70)

## Camera Movement Tracking
var DISTANCE = DEFAULT_DISTANCE
var MIN_DISTANCE = 7.5
var MAX_DISTANCE = 17.5
var HEIGHT = DEFAULT_HEIGHT
var GRADE = DEFAULT_GRADE
var OFFSET_POSITION = []

## Camera Movement Parameters
var ANGLE_CHANGE = deg_to_rad(2.5)
var SPRINT_SPEED = 0.15
var UNLIMITED_OFFSET = true

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	reset_camera()
	pass

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CAMERA_MODE == CAMERA_MODE_ENUM.SURROUND:
		apply_offset()
		pass
	if CAMERA_MODE == CAMERA_MODE_ENUM.LEASHED:
		center_camera()
	if CAMERA_MODE == CAMERA_MODE_ENUM.SPRINT:
		sprint(delta)

## Called when user input is detected. 'event' is said user input.
func _input(event):
	pass

## BULK ------------------------------------------------------------------------

## Sets the CAMERA_MODE based on paret's MOVEMENT_MODE
func set_camera_mode(VIEWING_MODE):
	if VIEWING_MODE == $"..".VIEWING_MODE_ENUM.ORBIT:
		CAMERA_MODE = CAMERA_MODE_ENUM.SURROUND
	if VIEWING_MODE == $"..".VIEWING_MODE_ENUM.FOLLOW:
		#CAMERA_MODE = CAMERA_MODE_ENUM.LEASHED
		center_camera()
	if VIEWING_MODE == $"..".VIEWING_MODE_ENUM.EXTEND:
		CAMERA_MODE = CAMERA_MODE_ENUM.SPRINT

## Rotates the camera horizontally, according to CAMERA_MODE
func rotate_horizontal(left):
	if CAMERA_MODE == CAMERA_MODE_ENUM.LEASHED:
		CAMERA_MODE = CAMERA_MODE_ENUM.SURROUND
	
	var adjusted_angle_change = ANGLE_CHANGE * (1 if left else -1)
	if CAMERA_MODE == CAMERA_MODE_ENUM.SURROUND:
		rotate_around_ball(adjusted_angle_change)
	else:
		swivel_by(adjusted_angle_change)

## Rotates the camera vertically
func rotate_vertical(up):
	if CAMERA_MODE == CAMERA_MODE_ENUM.LEASHED:
		CAMERA_MODE = CAMERA_MODE_ENUM.SURROUND
	
	$".".rotation.x += (1 if up else -1) * ANGLE_CHANGE * 0.5
	
	if $".".rotation.x > deg_to_rad(-20):
		$".".rotation.x = deg_to_rad(-20)
	elif $".".rotation.x < deg_to_rad(-65):
		$".".rotation.x = deg_to_rad(-65)
	pass

## "Sprints" the camera toward the cursor
func sprint(delta):
	# Get direction to move camera
	var cursor_position = get_viewport().get_mouse_position()
	var screensize = get_viewport().size
	
	var expand = true
	if cursor_position[1]/screensize[1] < 0.1:
		expand = false
	
	DISTANCE += SPRINT_SPEED * (1 if expand else -1)
	DISTANCE = MIN_DISTANCE if DISTANCE < MIN_DISTANCE else (MAX_DISTANCE if DISTANCE > MAX_DISTANCE else DISTANCE)
	var new_position = dlib.vector_to_xy([$".".rotation.y, DISTANCE])
	OFFSET_POSITION = new_position
	apply_offset()

## UTILITY ---------------------------------------------------------------------

## Sets camera to default position and rotation
func reset_camera():
	CAMERA_MODE = CAMERA_MODE_ENUM.SURROUND
	DISTANCE = DEFAULT_DISTANCE
	OFFSET_POSITION = dlib.vector_to_xy([deg_to_rad(0), DISTANCE])
	HEIGHT = DEFAULT_HEIGHT
	GRADE = DEFAULT_GRADE
	
	apply_offset()
	face_ball()
	$".".rotation.x = GRADE

## Recenters camera on ball
func center_camera():
	# TODO: Make smooth
	DISTANCE = DEFAULT_DISTANCE
	HEIGHT = DEFAULT_HEIGHT
	#GRADE = $".".rotation.y
	
	var velocity_angle = dlib.xy_to_vector([$"../Ball".linear_velocity.x, $"../Ball".linear_velocity.z])
	OFFSET_POSITION = dlib.vector_to_xy([velocity_angle[0] + deg_to_rad(180), DISTANCE])
	
	apply_offset()
	face_ball()

## Sets camera position by setting cam position to ball position + offset position
func apply_offset():
	$".".position.x = $"../Ball".position.x + OFFSET_POSITION[0]
	$".".position.y = $"../Ball".position.y + HEIGHT
	$".".position.z = $"../Ball".position.z + OFFSET_POSITION[1]

## Sets rotation of camera to face ball
func face_ball():
	var new_angle = get_rotation_to_ball()
	swivel_by(new_angle)

## Returns current rotation change needed to look directly at ball
func get_rotation_to_ball():
	var angle = dlib.xy_to_angle([$".".position.x - $"../Ball".position.x, $".".position.z - $"../Ball".position.z])
	return angle - $".".rotation.y

## Updates POSITION variable
func set_position(new_position):
	$".".position.x = new_position[0]
	$".".position.y = HEIGHT
	$".".position.z = new_position[1]
	OFFSET_POSITION = [$".".position.x - $"../Ball".position.x, $".".position.z - $"../Ball".position.z]

## Sets ANGLE globals
func set_horizontal_rotation(new_rotation):
	$".".rotation.y = new_rotation

## Alters position and rotation of camera to raim in orbit facing ballm 
func rotate_around_ball(rotation_change):
	swivel_by(rotation_change)
	var new_position = dlib.vector_to_xy([$".".rotation.y, DISTANCE])
	OFFSET_POSITION = new_position
	apply_offset()

## Alters ANGLE globals
func swivel_by(rotation_change):
	$".".rotation.y += rotation_change

## =================================================================================================
