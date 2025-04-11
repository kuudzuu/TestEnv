extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Movement Modes

## ORBIT: Rotates around puck, facing puck
## EXTEND: Rotates in place, and moves across map towards cursor
## FOLLOW: Attached "behind" puck "looking forwards" (velocity determines direction)
enum VIEWING_MODE_ENUM {ORBIT, EXTEND, FOLLOW}
var VIEWING_MODE: VIEWING_MODE_ENUM

## LINEAR: Applies straight-line vector based on mouse drag
## TRACE: Applies curved vector path based on mouse drag
## Realtime: Continuously applies force to puck based on continuous mouse drag
enum MOVEMENT_MODE_ENUM {LINEAR, TRACE, REALTIME}
@export var MOVEMENT_MODE: MOVEMENT_MODE_ENUM

## Children
@onready var Camera = $Camera3D
@onready var Ball = $Ball

## User Input
var MOUSE_CLICK_POSITION: Vector2
var MOUSE_RELEASE_POSITION: Vector2

## User Input v2 lol
var TRACING = false
var MOUSE_PATH = []
var PREV_MOUSE_POS = Vector2(0,0)

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_puck()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Has to be in process for continuous polling of key presses
	# NOTE: WASD was added to Project -> Project Settings -> Input Map -> ui_xyz
	if Input.is_action_pressed("ui_left"): # 'a' added to "ui_left"
		process_WASD("A")
	if Input.is_action_pressed("ui_right"): # 'd' added to "ui_right"
		process_WASD("D")
	if Input.is_action_pressed("ui_up"): # 'w' added to "ui_up"
		process_WASD("W")
	if Input.is_action_pressed("ui_down"): # 's' added to "ui_down"
		process_WASD("S")
	if Input.is_action_pressed("ui_break"): # 'shift' added to new ui action "ui_break"
		Ball.break_ball()
	
	if MOVEMENT_MODE == MOVEMENT_MODE_ENUM.TRACE:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			TRACING = true
			MOUSE_PATH.append(get_viewport().get_mouse_position())
		else:
			if TRACING:
				Ball.apply_force_path(MOUSE_PATH)
				MOUSE_PATH = []
				TRACING = false
	elif MOVEMENT_MODE == MOVEMENT_MODE_ENUM.REALTIME:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			if TRACING:
				var new_force = dlib.vector_between_xy(get_viewport().get_mouse_position(), PREV_MOUSE_POS)
				new_force[0] += fmod(Camera.rotation.y, deg_to_rad(360))
				if new_force[1] >= 0:
					#new_force[1] = 50
					Ball.apply_force_linear(new_force)
			else:
				TRACING = true
			PREV_MOUSE_POS = get_viewport().get_mouse_position()
		else:
			TRACING = false

# Called on user input
func _input(event):
	if MOVEMENT_MODE == MOVEMENT_MODE_ENUM.LINEAR:
		if event is InputEventMouseButton and event.button_index == 2:
			if event.pressed:
				MOUSE_CLICK_POSITION = event.position
			else:
				MOUSE_RELEASE_POSITION = event.position
				var force_vector = dlib.xy_to_vector([MOUSE_CLICK_POSITION.x-MOUSE_RELEASE_POSITION.x, MOUSE_CLICK_POSITION.y-MOUSE_RELEASE_POSITION.y])
				force_vector[0] += fmod(Camera.rotation.y, deg_to_rad(360))
				Ball.apply_force_linear(force_vector)
	
	#var screensize = get_viewport().size
	#if event is InputEventMouseMotion:
	#	if event.position[1]/screensize[1] < 0.1 or event.position[1]/screensize[1] > 0.9:
	#		update_movement_mode(MOVEMENT_MODE_ENUM.EXTEND)
	#	elif MOVEMENT_MODE == MOVEMENT_MODE_ENUM.EXTEND:
	#		update_movement_mode(MOVEMENT_MODE_ENUM.ORBIT)
		
	if event is InputEventKey:
		if event.keycode == 32: #Space
			update_movement_mode(VIEWING_MODE_ENUM.FOLLOW)
		if event.keycode == 82: #R
			reset_puck()

## BULK ------------------------------------------------------------------------

## Processes user input (particularly, WASD input)
func process_WASD(key):
	if VIEWING_MODE == VIEWING_MODE_ENUM.FOLLOW:
		update_movement_mode(VIEWING_MODE_ENUM.ORBIT)
	if key in ["A", "D"]:
		Camera.rotate_horizontal(key == "A")
	else:
		Camera.rotate_vertical(key == "W")

## Where event is an encoding of new movement mode
func update_movement_mode(NEW_MODE):
	VIEWING_MODE = NEW_MODE
	Camera.set_camera_mode(NEW_MODE)

## UTILITY ---------------------------------------------------------------------

## Resets puck
func reset_puck():
	# Set MOVEMENT_MODE to default (ORBIT) via call to function
	# 	which updates this file's movement mode as well as Camera's camera mode
	# 	something like an internal set_movement_mode() func call
	Ball.reset_ball()
	Camera.reset_camera()
	pass

## =================================================================================================
