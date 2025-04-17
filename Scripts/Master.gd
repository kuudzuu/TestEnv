extends Node

## Scenes
@onready var ARENA_SCENE = preload("res://Scenes/Terrain/Arena2.tscn")
@onready var PUCK_SCENE = preload("res://Scenes/Entities/Puck.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var Arena = ARENA_SCENE.instantiate()
	var Puck = PUCK_SCENE.instantiate()
	add_child(Arena)
	add_child(Puck)
	
	#Arena.initialize(Puck)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
