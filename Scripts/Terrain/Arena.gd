extends Node

var PUCK: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(puck_ref):
	PUCK = puck_ref
	$Area/KillFloor/Area3D.initialize(PUCK)

func kill_player():
	PUCK.reset_puck()
