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

func input_to_movement_v6(curr_mouse_pos, cam_rotation):
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
		print(factor)
		new_force[1] *= factor
		#new_force[1] = clamp(pow(FIXED_FORCE, FORCE_TIMER*10), 0, 30)
		
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

# A little too sluggish, no good "throw" [[fixed]]
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
		new_force[1] = clamp(pow(FIXED_FORCE, FORCE_TIMER*10), 0, 30)
		
		# Alter angle over time
		var old_angle = PREV_FORCE[0]
		var new_angle = new_force[0]
		var alteration_percent = clamp(1/pow(ANGLE_TIMER-0.5, 1.3) - 1/ANGLE_TIMER, 0, 1)
		print(alteration_percent)
		var actual_angle = (old_angle * (alteration_percent)) + (new_angle * (1-alteration_percent))
		new_force[0] = actual_angle
		
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

# No driving, sliiightly too snappy [[fixed]]
func input_to_movement_v3(curr_mouse_pos, cam_rotation):
	if ABORT:
		return null
	
	if TRACING: 
		var new_force = dlib.vector_between_xy(curr_mouse_pos, PREV_MOUSE_POS)
		new_force[0] += fmod(cam_rotation, deg_to_rad(360))
		
		if new_force[1] <= 5:
			return null
		
		if PREV_FORCE and new_force[1] >= PREV_FORCE[1] or !HIGHEST_FORCE: # Updated highest force seen so far
			HIGHEST_FORCE = new_force
		elif new_force[1] <= FORCE_PERCENT_CUTOFF * HIGHEST_FORCE[1]: # Stop adding force if we've dipped too far below most recent highest
			ABORT = true
			return null
		
		# Alter force over time:
		new_force[1] = pow(FIXED_FORCE, FORCE_TIMER*16)
		
		# Enables us to track how long we've tracing, and what the last trace was
		PREV_MOUSE_POS = curr_mouse_pos
		FORCE_TIMER += FORCE_TIMER_ADDITION
		FRAMES += 1
		PREV_FORCE = new_force
		return new_force
	else:
		TRACING = true
	
	# Enables us to track how long we've tracing, and what the last trace was
	PREV_MOUSE_POS = curr_mouse_pos
	FORCE_TIMER += 1

# EXTREMELY snappy [[not fixed]]
func input_to_movement_v2p5(curr_mouse_pos, cam_rotation):
	if TRACING: 
		var new_force = dlib.vector_between_xy(curr_mouse_pos, PREV_MOUSE_POS)
		new_force[0] += fmod(cam_rotation, deg_to_rad(360))
		
		# Updated highest force seen so far
		if PREV_FORCE and new_force[1] >= PREV_FORCE[1]:
			HIGHEST_FORCE = new_force
		
		# Stop adding force if we've dipped too far below most recent
		if new_force[1] <= FORCE_PERCENT_CUTOFF * PREV_FORCE[1]:
			PREV_FORCE = new_force
			return null
		
		PREV_FORCE = new_force
		return new_force
	else:
		TRACING = true
	
	# Enables us to track how long we've tracing, and what the last trace was
	PREV_MOUSE_POS = curr_mouse_pos
	FORCE_TIMER += 1

# "Drive" ball around when holding, snappy [[not fixed]]
func input_to_movement_v1(curr_mouse_pos, cam_rotation):
	if TRACING: 
		var new_force = dlib.vector_between_xy(curr_mouse_pos, PREV_MOUSE_POS)
		new_force[0] += fmod(cam_rotation, deg_to_rad(360))
		if new_force[1] >= 0:
			new_force[1] *= FORCE_MULT
			return new_force
	else:
		TRACING = true
	
	# Enables us to track how long we've tracing, and what the last trace was
	PREV_MOUSE_POS = curr_mouse_pos
	FORCE_TIMER += 1

# "Drive" ball around when holding, mushy [[not fixed]]
func input_to_movement_v0(curr_mouse_pos, cam_rotation):
	if TRACING: 
		var new_force = dlib.vector_between_xy(curr_mouse_pos, PREV_MOUSE_POS)
		new_force[0] += fmod(cam_rotation, deg_to_rad(360))
		new_force[1] *= 0.1
		return new_force
	else:
		TRACING = true
	
	# Enables us to track how long we've tracing, and what the last trace was
	PREV_MOUSE_POS = curr_mouse_pos
	FORCE_TIMER += 1

func get_last_force():
	if PREV_FORCE:
		print(PREV_FORCE)
		return [PREV_FORCE[0], PREV_FORCE[1]*2]

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
