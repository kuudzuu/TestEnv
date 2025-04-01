extends Node

var distance_x = 0
var distance_y = 0
var distance_z = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	distance_x = $"../Ball".position.x - $".".position.x
	distance_y = $"../Ball".position.y - $".".position.y
	distance_z = $"../Ball".position.z - $".".position.z


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$".".position.x = $"../Ball".position.x - distance_x
	$".".position.y = $"../Ball".position.y - distance_y
	$".".position.z = $"../Ball".position.z - distance_z
