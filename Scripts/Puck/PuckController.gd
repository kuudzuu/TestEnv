extends Node

"""
Controls a Puck instance. Connects user input to various functionalities,
and allows parts of the player to speak to one another
"""

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()
var disclib = preload("res://Scripts/Puck/Disc/disclib.gd").new()

var GAME

## Movement Modes
enum MOVEMENT_MODE_ENUM {HIT, DRIFT}
var MOVEMENT_MODE: MOVEMENT_MODE_ENUM

## ORBIT: Rotates around puck, facing puck
## EXTEND: Rotates in place, and moves across map towards cursor
## FOLLOW: Attached "behind" puck "looking forwards" (velocity determines direction)
enum VIEWING_MODE_ENUM {ORBIT, DEV}
var VIEWING_MODE: VIEWING_MODE_ENUM

## Children
@onready var DISC = $Disc
@onready var CAMERA = $Camera3D
@onready var VIEWPORT = get_viewport()

var TRACING = false
var PREV_MOUSE_POS = Vector2(0,0)

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_puck()
	handle_ui_input(null)

func _physics_process(delta):
	handle_camera_input()
	handle_movement_input()
	handle_breaking()

# Called on user input
func _input(event):
	handle_ui_input(event)

func game_ref(game_ref):
	GAME = game_ref

## BULK ------------------------------------------------------------------------

func handle_movement_input():
	if Input.is_action_just_pressed("right_click"):
		disclib.prime_direct_force(VIEWPORT.get_mouse_position())
	elif Input.is_action_just_released("right_click"): # added "right_click" to Godot input map
		DISC.apply_direct_force(disclib.trigger_direct_force(VIEWPORT.get_mouse_position(), CAMERA.rotation.y))

## bro trust
func handle_camera_input():
	pass

func handle_ui_input(event):
	if event is InputEventKey and event.keycode == 82 and event.pressed == true: #R
		reset_puck()
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed == true:
		GAME.arena_exited()

func handle_breaking():
	if Input.is_action_pressed("ui_break"): # 'shift' added to new ui action "ui_break"
		DISC.break_ball()
	if Input.is_action_just_released("ui_break"):
		DISC.stop_braking()

## Resets puck
func reset_puck():
	DISC.reset_disc()
	CAMERA.reset_camera()

## =================================================================================================
