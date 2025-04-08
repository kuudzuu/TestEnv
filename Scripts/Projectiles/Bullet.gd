extends RigidBody3D

var SPEED = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".linear_velocity.x = 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
