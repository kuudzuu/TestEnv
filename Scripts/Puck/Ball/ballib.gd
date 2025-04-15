extends Node

"""
Takes care of specific intraPuck behaviors
"""

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Force tracking
var TRACING = false
var ABORT = false
var PREV_MOUSE_POS: Vector2
var PREV_FORCE = [0,0]

## Force parameters (alter forces added over time)
var HIGHEST_FORCE = Vector2(0,0)
var LOWEST_FORCE = Vector2(0,0)
var FORCE_TIMER = 1
var FORCE_TIMER_ADDITION = 2
var FIXED_FORCE = 1.03
var FORCE_MULT = 0.1
var FORCE_PERCENT_CUTOFF = 0.75

## Angle Parameters
var ANGLE_TIMER = 1.0
var ANGLE_TIMER_ADDITION = 0.5

## Timing Parameters
var FRAMES = 0
var MAX_FRAMES = 20

## FUNCTIONS =======================================================================================

func input_to_movement(curr_mouse_pos, cam_rotation):
	if ABORT:
		return null
	
	if TRACING: 
		# Obtain (and normalize direction of) the force to be added
		var new_force = dlib.vector_between_xy(curr_mouse_pos, PREV_MOUSE_POS)
		new_force[0] += fmod(cam_rotation, deg_to_rad(360))
		
		# Prevents acceleration from static mouse clicks
		if new_force[1] <= 5:
			FRAMES += 1
			return null
		
		# Auto end fling after 20 frames at most
		if FRAMES >= MAX_FRAMES:
			ABORT = true
			return null
		
		# Alter force over time
		var factor = 1 - (1/pow(FORCE_TIMER, 0.5))
		new_force[1] *= factor
		
		# Alter angle over time
		var alteration_percent = clamp(1/pow(ANGLE_TIMER-0.5, 1.3) - 1/ANGLE_TIMER, 0, 1)
		new_force[0] = (PREV_FORCE[0] * (alteration_percent)) + (new_force[0] * (1-alteration_percent))
		
		# Enables us to track how long we've tracing, and what the last trace was
		PREV_MOUSE_POS = curr_mouse_pos
		FORCE_TIMER += FORCE_TIMER_ADDITION
		ANGLE_TIMER += ANGLE_TIMER_ADDITION
		FRAMES += 1
		PREV_FORCE = new_force
		return new_force
	else:
		TRACING = true
	
	# Enables us to track how long we've tracing, and what the last trace was
	PREV_MOUSE_POS = curr_mouse_pos
	FORCE_TIMER += 1


func stop_movement_input():
	TRACING = false
	ABORT = false
	FRAMES = 0
	ANGLE_TIMER = 1.0
	FORCE_TIMER = 1.0
	PREV_FORCE = [0,0]

func percent_diff_in_angles(Ball, force_vector):
	var normalized_new_angle = rad_to_deg(force_vector[0]) + 180
	var curr_angle = rad_to_deg(dlib.xy_to_angle([Ball.linear_velocity.x, Ball.linear_velocity.z]))
	
	if curr_angle < 0:
		curr_angle += 360
	var angle_diff = abs(curr_angle - normalized_new_angle)
	if angle_diff > 180:
		angle_diff = 360 - angle_diff
	var alteration_percent = abs(angle_diff/180)
	if dlib.xy_to_mag([Ball.linear_velocity.x, Ball.linear_velocity.z]) < 5 or dlib.xy_to_mag([Ball.angular_velocity.x, Ball.angular_velocity.z]) < 5:
		#alteration_percent = 1
		pass
	alteration_percent = pow(alteration_percent,3)
	return alteration_percent

## =================================================================================================
