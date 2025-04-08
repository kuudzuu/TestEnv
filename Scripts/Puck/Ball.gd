extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Puck Variables
@export_group("Movement")
@export var GRAVITY_MULT = 5
@export var PUCK_MAX_SPEED = 30

## Misc Parameters
var BREAK_SPEED = 1.05

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	initialize_ball_params()
	reset_ball()

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

## Takes in a single-frame user force and applies it to Ball
## User force is in (angle, magnitude) format.
func apply_user_force(force_vector):
	var xz_change = dlib.vector_to_xy(force_vector)
	$".".linear_velocity.x -= xz_change[0]
	$".".linear_velocity.z -= xz_change[1]
	
	# consider making angular_velocity change for this too
	# There will be logic here at some point for "starting boosts" and shit
		# i.e. that thing abt "jumping" when force is directed "behind" ball according to velocity
	# consider capping speed

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
	var curr_velocity_magnitude = sqrt(pow($".".linear_velocity.x, 2) + pow($".".linear_velocity.z, 2))
	if curr_velocity_magnitude > PUCK_MAX_SPEED:
		var factor = PUCK_MAX_SPEED / curr_velocity_magnitude
		$".".linear_velocity.x = $".".linear_velocity.x * factor
		$".".linear_velocity.z = $".".linear_velocity.z * factor

## =================================================================================================
