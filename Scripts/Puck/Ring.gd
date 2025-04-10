extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## Scenes
@onready var BASIC_PROJ = preload("res://Scenes/Projectiles/Bullet.tscn")

## User Input
var PROJECTILE_CLICK_POSITION: Vector2
var PROJECTILE_RELEASE_POSITION: Vector2
var AIMING = false
var VALID_SHOT = false

## Misc Parameters
var PROJECTILE_OFFSET_MAGNITUDE = 1.5

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	pass

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$".".position = $"../Ball".position
	var facing_angle = get_firing_angle() - deg_to_rad(180)
	set_facing(facing_angle)
	if (PROJECTILE_CLICK_POSITION != get_viewport().get_mouse_position() and AIMING):
		$".".visible = true
		VALID_SHOT = true

# Called on user input
func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			PROJECTILE_CLICK_POSITION = event.position
			AIMING = true
		else:
			if VALID_SHOT:
				PROJECTILE_RELEASE_POSITION = event.position
				$".".fire()
				$".".visible = false
			AIMING = false
			VALID_SHOT = false

## BULK ------------------------------------------------------------------------

## Fire a projectile
func fire():
	var projectile_spawn_point = get_firing_location()
	var projectile_firing_angle = get_firing_angle()
	
	var basic_projectile = BASIC_PROJ.instantiate()
	add_sibling(basic_projectile)
	
	basic_projectile.shoot(projectile_spawn_point, projectile_firing_angle)

# Returns the facing angle of the projectile ring
func get_current_facing():
	return $".".rotation.y - deg_to_rad(180)

# Sets the facing angle of the projectile ring
func set_facing(angle):
	$".".rotation.y = angle

func get_firing_location():
	var firing_angle = get_firing_angle()
	var firing_offset = dlib.vector_to_xy([firing_angle, PROJECTILE_OFFSET_MAGNITUDE])
	return [$".".position.x + firing_offset[0], $".".position.y, $".".position.z + firing_offset[1]]

func get_firing_angle():
	if AIMING:
		var cursor_position = get_viewport().get_mouse_position()
		return dlib.angle_between_xy(PROJECTILE_CLICK_POSITION, cursor_position) + dlib.norm_cam_rot($"../Camera3D".rotation.y)
		#return dlib.xy_to_vector([cursor_position[0] - PROJECTILE_CLICK_POSITION[0], cursor_position[1] - PROJECTILE_CLICK_POSITION[1]])[0] + $"../Camera3D".rotation.y
	else:
		return dlib.angle_between_xy(PROJECTILE_CLICK_POSITION, PROJECTILE_RELEASE_POSITION) + dlib.norm_cam_rot($"../Camera3D".rotation.y)

## UTILITY ---------------------------------------------------------------------

## =================================================================================================
