extends Node

"""
Controls the Ball of a Puck instance.
Keeps track of various Puck physics parameters, and applies movement forces
"""

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()
var disclib = preload("res://Scripts/Puck/Disc/disclib.gd").new()

## Puck Variables
@export_group("Movement")
@export var GRAVITY_MULT: int
@export var PUCK_MAX_SPEED = 70
@export var PUCK_MAX_ANGULAR_SPEED = 1
@export var BREAK_SPEED = 1.075

var BRAKING = false

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	initialize_disc_params()
	reset_disc()
	cap_angular()

## BULK ------------------------------------------------------------------------

## Initializes this puck's specific values for all global puck parameters
func initialize_disc_params():
	$".".gravity_scale = GRAVITY_MULT

func apply_direct_force(force_vector):
	var xz_change = dlib.vector_to_xy(force_vector)
	$".".linear_velocity.x = -1 * xz_change[0]
	$".".linear_velocity.z = -1 * xz_change[1]


## UTILITY ---------------------------------------------------------------------

func reset_disc():
	$".".linear_velocity = Vector3(0,0,0)
	$".".angular_velocity = Vector3(0,0,0)
	$".".position = Vector3(0,1,0)
	$".".rotation = Vector3(0,0,0)

func break_ball():
	BRAKING = true
	$".".linear_velocity.x *= 1 / BREAK_SPEED
	$".".linear_velocity.z *= 1 / BREAK_SPEED

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
