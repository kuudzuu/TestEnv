extends RigidBody3D

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Misc Parameters
var SPEED = 30

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.

## BULK ------------------------------------------------------------------------

## Shoots the bullet
func shoot(firing_position, firing_angle):
	$".".position.x = firing_position[0]
	$".".position.y = firing_position[1]
	$".".position.z = firing_position[2]
	$".".rotation.y = firing_angle
	
	var new_velocity = dlib.vector_to_xy([firing_angle, SPEED])
	$".".linear_velocity.x = new_velocity[0]
	$".".linear_velocity.z = new_velocity[1]

## UTILITY ---------------------------------------------------------------------

## =================================================================================================
