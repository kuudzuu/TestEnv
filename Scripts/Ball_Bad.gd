extends Node

var mouse_click_pos = 0
var mouse_release_pos = 0
var mouse_go = 0

var BALL_MAX_SPEED = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#move_WASD(delta)
	#print($".".linear_velocity)
	move_cursor_changing_camera(delta)
	reset()
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_click_pos = event.position
		elif event.is_released:
			mouse_release_pos = event.position
			mouse_go = 1


func move_cursor_changing_camera(delta):
	if mouse_go == 1:
		mouse_go = 0
		var change = mouse_release_pos - mouse_click_pos
		
		$".".linear_velocity.x += change.x * delta * 3
		$".".linear_velocity.x = BALL_MAX_SPEED if $".".linear_velocity.x > BALL_MAX_SPEED else $".".linear_velocity.x
		$".".linear_velocity.x = -1*BALL_MAX_SPEED if $".".linear_velocity.x < -1*BALL_MAX_SPEED else $".".linear_velocity.x
		
		$".".linear_velocity.z += change.y * delta * 3
		$".".linear_velocity.z = BALL_MAX_SPEED if $".".linear_velocity.z > BALL_MAX_SPEED else $".".linear_velocity.z
		$".".linear_velocity.z = -1*BALL_MAX_SPEED if $".".linear_velocity.z < -1*BALL_MAX_SPEED else $".".linear_velocity.z


func move_mouse(delta):
	if mouse_go == 1:
		mouse_go = 0
		var change = mouse_release_pos - mouse_click_pos
		
		$".".linear_velocity.x += change.x * delta * 3
		$".".linear_velocity.x = BALL_MAX_SPEED if $".".linear_velocity.x > BALL_MAX_SPEED else $".".linear_velocity.x
		$".".linear_velocity.x = -1*BALL_MAX_SPEED if $".".linear_velocity.x < -1*BALL_MAX_SPEED else $".".linear_velocity.x
		
		$".".linear_velocity.z += change.y * delta * 3
		$".".linear_velocity.z = BALL_MAX_SPEED if $".".linear_velocity.z > BALL_MAX_SPEED else $".".linear_velocity.z
		$".".linear_velocity.z = -1*BALL_MAX_SPEED if $".".linear_velocity.z < -1*BALL_MAX_SPEED else $".".linear_velocity.z


func move_WASD(delta):
	var SPEED_AMT = 0.1
	var amt = 200 * delta
	if Input.is_physical_key_pressed(KEY_W):
		var mult = amt if $".".linear_velocity.z > 0 else amt/2
		$".".linear_velocity.z -= SPEED_AMT * mult
	if Input.is_physical_key_pressed(KEY_S):
		var mult = amt if $".".linear_velocity.z < 0 else amt/2
		$".".linear_velocity.z += SPEED_AMT * mult
	if Input.is_physical_key_pressed(KEY_D):
		var mult = amt if $".".linear_velocity.x < 0 else amt/2
		$".".linear_velocity.x += SPEED_AMT * mult
	if Input.is_physical_key_pressed(KEY_A):
		var mult = amt if $".".linear_velocity.x > 0 else amt/2

		$".".linear_velocity.x -= SPEED_AMT * mult


func reset():
	if Input.is_physical_key_pressed(KEY_R):
		$".".linear_velocity = Vector3(0,0,0)
		$".".position = Vector3(0,1,0)
		$".".angular_velocity = Vector3(0,0,0)
