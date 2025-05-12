extends Node

## GLOBALS =========================================================================================
## Libraries
var dlib = preload("res://Scripts/Utility/dlib.gd").new()

## References
@onready var DISC = $"../Disc"

## Camera positioning parameters
var FOCUS_POINT: Vector3
var FOCUS_OFFSET: Vector3

var ORBIT_SPHERE_RADIUS: float
var ORBIT_HEIGHT: float

var HORZ_ORBIT: float
var VERT_ORBIT: float
var HORZ_SWIVEL: float
var VERT_SWIVEL: float

## Defaults
var DEFAULT_ORBIT_SPHERE_RADIUS = 40.0
var DEFAULT_ORBIT_HEIGHT = 35.0

## FUNCTIONS =======================================================================================
## PREMADE ---------------------------------------------------------------------

## Called when the node enters the scene tree for the first time.
func _ready():
	reset_camera()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	FOCUS_POINT = DISC.position
	update_position()
	update_rotation()

## BULK ------------------------------------------------------------------------

## Sets camera to default position and rotation
func reset_camera():
	ORBIT_SPHERE_RADIUS = DEFAULT_ORBIT_SPHERE_RADIUS
	ORBIT_HEIGHT = DEFAULT_ORBIT_HEIGHT
	HORZ_ORBIT = 0
	VERT_ORBIT = 0

## Sets camera position to be specified offset from ball
func update_position():
	var current_radius = get_radius_by_height()
	var xz_offset = dlib.vector_to_xy([HORZ_ORBIT, current_radius])
	
	$".".position.x = FOCUS_POINT[0] + xz_offset[0]
	$".".position.y = FOCUS_POINT[1] + ORBIT_HEIGHT
	$".".position.z = FOCUS_POINT[2] + xz_offset[1]

func update_rotation():
	look_at_orbit_center()

## MODULAR ---------------------------------------------------------------------

## Sets camera rotation to look at center of orbit
func look_at_orbit_center():
	$".".look_at(DISC.position)

## Changes it's horizontal orbit position by the provided angle
## Keeps height and sphere radius the same
func orbit_horz(angle):
	pass

## Overrides horizontal orbit position with the provided angle
## Keeps height and sphere radius the same
func set_orbit_horz(angle):
	pass

## Changes it's vertical orbit position by the provided angle
## Keeps height and sphere radius the same
func orbit_vert(angle):
	pass

## Overrides vertical orbit position with the provided angle
## Keeps height and sphere radius the same
func set_orbit_vert(angle):
	pass

## Moves camera closer or further from ball
## Effectively enlarging orbit sphere radius
func zoom(distance):
	pass

## Sets camera to certain distance from ball
## Overwrites orbit sphere radius
func set_zoom(distance):
	pass

func swivel_horz(angle):
	pass

func set_swivel_horz(angle):
	pass

func swivel_vert(angle):
	pass

func set_swivel_vert(angle):
	pass

## SELF LIB --------------------------------------------------------------------

## Returns the radius of the cross section of the orbit sphere we are in based on height
func get_radius_by_height():
	return sqrt(pow(ORBIT_SPHERE_RADIUS, 2) - pow(abs(ORBIT_HEIGHT), 2))

## -----------------------------------------------------------------------------
## =================================================================================================
