extends Node

"""
Takes care of specific intraPuck behaviors
"""

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Force tracking
var PREV_MOUSE_POS: Vector2

## Force parameters
var FORCE_MAX = 75
var FORCE_FACTOR = 0.15

## FUNCTIONS =======================================================================================

func prime_direct_force(curr_mouse_pos):
	PREV_MOUSE_POS = curr_mouse_pos

func trigger_direct_force(curr_mouse_pos, cam_rotation):
	var new_force = dlib.vector_between_xy(curr_mouse_pos, PREV_MOUSE_POS)
	
	# Normalize direction
	new_force[0] += fmod(cam_rotation, deg_to_rad(360))
	
	# Normalize force
	new_force[1] *= FORCE_FACTOR
	new_force[1] = clamp(new_force[1], 0, FORCE_MAX)
	
	return new_force


## =================================================================================================
