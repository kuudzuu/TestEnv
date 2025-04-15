extends Node

"""
Controls the Ball of a Puck instance.
Keeps track of various Puck physics parameters, and applies movement forces
"""

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()
var ballib = preload("res://Scripts/Puck/Ball/ballib.gd").new()

## Puck Variables
@export_group("Movement")
@export var GRAVITY_MULT = 5
@export var PUCK_MAX_SPEED = 70
@export var PUCK_MAX_ANGULAR_SPEED = 1
@export var PIVOT_BOOST = 1.8
@export var BREAK_SPEED = 1.05

var BRAKING = false

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	initialize_ball_params()
	reset_ball()
	cap_angular()
	$"../Projectile Ring".visible = false

## BULK ------------------------------------------------------------------------

## Initializes this puck's specific values for all global puck parameters
func initialize_ball_params():
	$".".gravity_scale = GRAVITY_MULT

## Takes in a single-frame user force and applies it to Ball
## User force is in (angle, magnitude) format.
func apply_force(force_vector):
	# Calculating difference in travelling angle vs added angle
	var alteration_percent = ballib.percent_diff_in_angles($".", force_vector)
	
	# Raw force addition
	var xz_change = dlib.vector_to_xy(force_vector)
	$".".linear_velocity.x -= xz_change[0]
	$".".linear_velocity.z -= xz_change[1]
	# Adding pivot boost
	var xz_change_boost = dlib.vector_to_xy([force_vector[0], force_vector[1] * -1 * (0.05 if BRAKING else PIVOT_BOOST)])
	$".".linear_velocity.x = dlib.blend_linear(xz_change_boost[0], $".".linear_velocity.x, alteration_percent)
	$".".linear_velocity.z = dlib.blend_linear(xz_change_boost[1], $".".linear_velocity.z, alteration_percent)

	# Raw force addition
	var new_angular_x = -1 * xz_change[1]
	var new_angular_z = xz_change[0]
	# Accounting for pivot boosting
	if !BRAKING:
		$".".angular_velocity.x = dlib.blend_linear(new_angular_x, $".".angular_velocity.x, alteration_percent)
		$".".angular_velocity.y = 0
		$".".angular_velocity.z = dlib.blend_linear(new_angular_z, $".".angular_velocity.z, alteration_percent)
	
	cap_speed()


## UTILITY ---------------------------------------------------------------------

func reset_ball():
	$".".linear_velocity = Vector3(0,0,0)
	$".".angular_velocity = Vector3(0,0,0)
	$".".position = Vector3(0,1,0)

func break_ball():
	BRAKING = true
	$".".linear_velocity.x *= 1 / BREAK_SPEED
	$".".linear_velocity.z *= 1 / BREAK_SPEED
	$".".angular_velocity.x *= 1 / BREAK_SPEED
	$".".angular_velocity.y *= 1 / BREAK_SPEED
	$".".angular_velocity.z *= 1 / BREAK_SPEED

func stop_braking():
	BRAKING = false

func cap_speed():
	var curr_velocity_magnitude = dlib.xy_to_mag([$".".linear_velocity.x, $".".linear_velocity.z])
	if curr_velocity_magnitude > PUCK_MAX_SPEED:
		var factor = PUCK_MAX_SPEED / curr_velocity_magnitude
		$".".linear_velocity.x = $".".linear_velocity.x * factor
		$".".linear_velocity.z = $".".linear_velocity.z * factor

func cap_angular():
	var curr_angular_magnitude = dlib.xy_to_mag($".".angular_velocity)
	if curr_angular_magnitude > PUCK_MAX_ANGULAR_SPEED:
		var factor = PUCK_MAX_ANGULAR_SPEED / curr_angular_magnitude
		$".".angular_velocity.x = $".".angular_velocity.x * factor
		$".".angular_velocity.y = $".".angular_velocity.y * factor
		$".".angular_velocity.z = $".".angular_velocity.z * factor

## =================================================================================================
