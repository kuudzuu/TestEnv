extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Puck Variables
@export_group("Movement")
@export var GRAVITY_MULT = 5
@export var PUCK_MAX_SPEED = 70

## Movement Parameters
var FIXED_FORCE = true
var FORCE = 20
var FORCE_MULT = 0.02

## Misc Parameters
var BREAK_SPEED = 1.05
var PIVOT_BOOST = 1.5

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	initialize_ball_params()
	reset_ball()
	$"../Projectile Ring".visible = false

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Called when user input is detected. 'event' is said user input.
func _input(event):
	pass

## BULK ------------------------------------------------------------------------

## Initializes this puck's specific values for all global puck parameters
func initialize_ball_params():
	$".".gravity_scale = GRAVITY_MULT

## Takes an array of cursor coordinates from force path traced by player and applies to ball
func apply_force_path(force_path):
	pass

## Takes in a single-frame user force and applies it to Ball
## User force is in (angle, magnitude) format.
func apply_user_force(force_vector):
	if FIXED_FORCE:
		force_vector[1] = FORCE
	else:
		force_vector[1] *= FORCE_MULT
		
	# -----------------
	
	var normalized_new_angle = rad_to_deg(force_vector[0]) + 180
	var curr_angle = rad_to_deg(dlib.xy_to_angle([$".".linear_velocity.x, $".".linear_velocity.z]))
	if curr_angle < 0:
		curr_angle += 360
	var angle_diff = abs(curr_angle - normalized_new_angle)
	if angle_diff > 180:
		angle_diff = 360 - angle_diff
	var alteration_percent = abs(angle_diff/180)
	if dlib.xy_to_mag([$".".linear_velocity.x, $".".linear_velocity.z]) < 5:
		alteration_percent = 1
	alteration_percent = pow(alteration_percent,3)
	
	# -----------------
	
	var xz_change = dlib.vector_to_xy(force_vector)
	var xz_change_boost = dlib.vector_to_xy([force_vector[0], force_vector[1] * -1 * PIVOT_BOOST])
	
	$".".linear_velocity.x -= xz_change[0]
	$".".linear_velocity.z -= xz_change[1]
	
	$".".linear_velocity.x = ($".".linear_velocity.x * (1 - alteration_percent)) + (xz_change_boost[0] * alteration_percent)
	$".".linear_velocity.z = ($".".linear_velocity.z * (1 - alteration_percent)) + (xz_change_boost[1] * alteration_percent)
	
	cap_speed()

func break_ball():
	$".".linear_velocity.x *= 1 / BREAK_SPEED
	$".".linear_velocity.z *= 1 / BREAK_SPEED
	$".".angular_velocity.x *= 1 / BREAK_SPEED
	$".".angular_velocity.y *= 1 / BREAK_SPEED
	$".".angular_velocity.z *= 1 / BREAK_SPEED

## UTILITY ---------------------------------------------------------------------

## Sets ball position, rotation, and velocity to zero
func reset_ball():
	$".".linear_velocity = Vector3(0,0,0)
	$".".angular_velocity = Vector3(0,0,0)
	$".".position = Vector3(0,1,0)

func cap_speed():
	var curr_velocity_magnitude = dlib.xy_to_mag([$".".linear_velocity.x, $".".linear_velocity.z])
	if curr_velocity_magnitude > PUCK_MAX_SPEED:
		var factor = PUCK_MAX_SPEED / curr_velocity_magnitude
		$".".linear_velocity.x = $".".linear_velocity.x * factor
		$".".linear_velocity.z = $".".linear_velocity.z * factor

## =================================================================================================
