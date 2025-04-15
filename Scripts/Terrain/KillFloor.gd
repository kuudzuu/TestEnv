extends Node

var PUCK: Node3D
var DISC: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var bodies = $".".get_overlapping_bodies()
	
	
	
	if $".".overlaps_body(DISC):
		$"../../..".kill_player()

func initialize(puck_ref):
	PUCK = puck_ref
	var children = PUCK.get_children()
	DISC = children[1]
