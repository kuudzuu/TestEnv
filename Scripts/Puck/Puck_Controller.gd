extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Movement Modes
enum MOVEMENT_MODE_ENUM {ORBIT, EXTEND, FOLLOW}
## ORBIT: Rotates around puck, facing puck ///
## EXTEND: Rotates in place, and moves across map towards cursor ///
## FOLLOW: Attached "behind" puck "looking forwards" (velocity determines direction) ///
@export var MOVEMENT_MODE: MOVEMENT_MODE_ENUM

## Children
@onready var Camera = $Camera3D
@onready var Ball = $Ball

## User Input
var MOUSE_CLICK_POSITION: Vector2
var MOUSE_RELEASE_POSITION: Vector2

## User Input v2 lol
var MOUSE_PATH = []

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
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		print("tracing")
	else:
		print("still")

# Called on user input
func _input(event):
	if event is InputEventMouseButton and event.button_index == 2:
		print("tracing")
	
	#if event is InputEventMouseButton and event.button_index == 2:
	#	if event.pressed:
	#		MOUSE_CLICK_POSITION = event.position
	#	else:
	#		MOUSE_RELEASE_POSITION = event.position
	#		var force_vector = dlib.xy_to_vector([MOUSE_CLICK_POSITION.x-MOUSE_RELEASE_POSITION.x, MOUSE_CLICK_POSITION.y-MOUSE_RELEASE_POSITION.y])
	#		force_vector[0] += fmod(Camera.rotation.y, deg_to_rad(360))
	#		Ball.apply_user_force(force_vector)
	
	#var screensize = get_viewport().size
	#if event is InputEventMouseMotion:
	#	if event.position[1]/screensize[1] < 0.1 or event.position[1]/screensize[1] > 0.9:
	#		update_movement_mode(MOVEMENT_MODE_ENUM.EXTEND)
	#	elif MOVEMENT_MODE == MOVEMENT_MODE_ENUM.EXTEND:
	#		update_movement_mode(MOVEMENT_MODE_ENUM.ORBIT)
		
	if event is InputEventKey:
		if event.keycode == 32: #Space
			update_movement_mode(MOVEMENT_MODE_ENUM.FOLLOW)
		if event.keycode == 82: #R
			reset_puck()
	
	pass

## BULK ------------------------------------------------------------------------

## Processes user input (particularly, WASD input)
func process_WASD(key):
	if MOVEMENT_MODE == MOVEMENT_MODE_ENUM.FOLLOW:
		update_movement_mode(MOVEMENT_MODE_ENUM.ORBIT)
	if key in ["A", "D"]:
		Camera.rotate_horizontal(key == "A")
	else:
		Camera.rotate_vertical(key == "W")
	pass

## Where event is an encoding of new movement mode
func update_movement_mode(NEW_MODE):
	MOVEMENT_MODE = NEW_MODE
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
