extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Scenes
@onready var BULLET_SCENE = preload("res://Scenes/Projectiles/Bullet.tscn")

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
var mouse_click_position: Vector2
var mouse_release_position: Vector2

var projectile_click_position: Vector2
var projectile_release_position: Vector2

## Misc Parameters
var FIXED_FORCE = true
var FORCE = 20
var FORCE_MULT = 0.02

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
	

# Called on user input
func _input(event):
	if event is InputEventMouseButton and event.button_index == 2: #and event.button_index == 1:
		if event.pressed:
			mouse_click_position = event.position
		else:
			mouse_release_position = event.position
			var force_vector = dlib.xy_to_vector([mouse_click_position.x-mouse_release_position.x, mouse_click_position.y-mouse_release_position.y])
			force_vector[0] += Camera.rotation.y
			if FIXED_FORCE:
				force_vector[1] = FORCE
			else:
				force_vector[1] *= FORCE_MULT
			Ball.apply_user_force(force_vector)
	
	if event is InputEventMouseButton and event.button_index == 1: #and event.button_index == 1:
		if event.pressed:
			projectile_click_position = event.position
		else:
			projectile_release_position = event.position
			fire()

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

## Fire a projectile
func fire():
	var raw_fire_xy = [projectile_click_position.x - projectile_release_position.x, projectile_click_position.y - projectile_release_position.y]
	var firing_angle = dlib.xy_to_vector(raw_fire_xy)[0] + deg_to_rad(180) + Camera.rotation.y
	var firing_origin = dlib.get_offset_from_point($Ball.position, firing_angle, $Ball/CollisionShape3D.shape.radius * 1.5)
	
	var projectile = BULLET_SCENE.instantiate()
	projectile.position.x = firing_origin[0]
	projectile.position.y = $Ball.position.y
	projectile.position.z = firing_origin[1]
	add_sibling(projectile)
	
	var projectile_velocity_change = dlib.vector_to_xy([firing_angle, 20])
	projectile.linear_velocity.x = projectile_velocity_change[0]
	projectile.linear_velocity.z = projectile_velocity_change[1]
	pass

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
