extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Camera positioning parameters
var FOCUS_POINT: Vector3
var FOCUS_OFFSET: Vector3
var RADIUS: float
var HEIGHT2: float
var HORZ_ORBIT: float
var VERT_ORBIT: float

## Defauls
var DEFAULT_FOCUS_DISTANCE = 10.0

## -------

## Defaults
var DEFAULT_DISTANCE = 10.0
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
var ANGLE_CHANGE = deg_to_rad(1)
var SPRINT_SPEED = 0.15
var UNLIMITED_OFFSET = true

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	reset_camera()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_horizontal(true)
	#apply_offset()

## BULK ------------------------------------------------------------------------

## Sets camera to default position and rotation
func reset_camera():
	
	DISTANCE = DEFAULT_DISTANCE
	OFFSET_POSITION = dlib.vector_to_xy([deg_to_rad(0), DISTANCE])
	HEIGHT = DEFAULT_HEIGHT
	GRADE = DEFAULT_GRADE
	
	apply_offset()
	face_ball()
	$".".rotation.x = GRADE

## MODULAR ---------------------------------------------------------------------

## Orbits horizontally
func orbit_horz(angle):
	pass

## -----------------------------------------------------------------------------



## Rotates the camera horizontally, according to CAMERA_MODE
func rotate_horizontal(left):
	var adjusted_angle_change = ANGLE_CHANGE * (1 if left else -1)
	rotate_around_ball(adjusted_angle_change)

## Rotates the camera vertically
func rotate_vertical(up):
	
	$".".rotation.x += (1 if up else -1) * ANGLE_CHANGE * 0.5
	
	if $".".rotation.x > deg_to_rad(-20):
		$".".rotation.x = deg_to_rad(-20)
	elif $".".rotation.x < deg_to_rad(-65):
		$".".rotation.x = deg_to_rad(-65)

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



## Recenters camera on ball
func center_camera():
	# TODO: Make smooth
	DISTANCE = DEFAULT_DISTANCE
	HEIGHT = DEFAULT_HEIGHT
	#GRADE = $".".rotation.y
	
	var velocity_angle = dlib.xy_to_vector([$"../Disc".linear_velocity.x, $"../Disc".linear_velocity.z])
	OFFSET_POSITION = dlib.vector_to_xy([velocity_angle[0] + deg_to_rad(180), DISTANCE])
	
	apply_offset()
	face_ball()

## Sets camera position by setting cam position to ball position + offset position
func apply_offset():
	$".".position.x = $"../Disc".position.x + OFFSET_POSITION[0]
	$".".position.y = $"../Disc".position.y + HEIGHT
	$".".position.z = $"../Disc".position.z + OFFSET_POSITION[1]

## Sets rotation of camera to face ball
func face_ball():
	var new_angle = get_rotation_to_ball()
	swivel_horz(new_angle)

## Returns current rotation change needed to look directly at ball
func get_rotation_to_ball():
	var angle = dlib.xy_to_angle([$".".position.x - $"../Disc".position.x, $".".position.z - $"../Disc".position.z])
	return angle - $".".rotation.y

## Updates POSITION variable
func set_position(new_position):
	$".".position.x = new_position[0]
	$".".position.y = HEIGHT
	$".".position.z = new_position[1]
	OFFSET_POSITION = [$".".position.x - $"../Disc".position.x, $".".position.z - $"../Disc".position.z]

## Sets ANGLE globals
func set_horizontal_rotation(new_rotation):
	$".".rotation.y = new_rotation

## Alters position and rotation of camera to raim in orbit facing ballm 
func rotate_around_ball(rotation_change):
	swivel_horz(rotation_change)
	var new_position = dlib.vector_to_xy([$".".rotation.y, DISTANCE])
	OFFSET_POSITION = new_position
	apply_offset()

## Alters ANGLE globals
func swivel_horz(rotation_change):
	$".".rotation.y += rotation_change

func swivel_vert(rotation_change):
	$".".rotation.x += rotation_change

## =================================================================================================
