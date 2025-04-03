extends Node

var distance_x = 0
var distance_y = 0
var distance_z = 0
var total_distance_horz = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	distance_x = $"../Ball".position.x - $".".position.x
	distance_y = $"../Ball".position.y - $".".position.y
	distance_z = $"../Ball".position.z - $".".position.z
	total_distance_horz = sqrt(pow(distance_x,2) + pow(distance_z,2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_static()
	#move_cursor()


func move_static():
	$".".position.x = $"../Ball".position.x - distance_x
	$".".position.y = $"../Ball".position.y - distance_y
	$".".position.z = $"../Ball".position.z - distance_z


func move_cursor():
	var ball_velocity = $"../Ball".linear_velocity
	var ball_tan = atan2(ball_velocity.z, ball_velocity.x)
	var factor = total_distance_horz/sqrt(pow(ball_velocity.x,2) + pow(ball_velocity.z,2))
	
	$".".position.x = $"../Ball".position.x - ball_velocity.x * factor
	$".".position.y = $"../Ball".position.y - distance_y
	$".".position.z = $"../Ball".position.z - ball_velocity.z * factor
	
	$".".look_at($"../Ball".global_position)
	print($".".rotation)
	
	#$".".rotation.y = tan(ball_velocity.z/ball_velocity.x)
	pass
