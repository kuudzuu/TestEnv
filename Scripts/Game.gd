extends Node

## Scenes
@onready var TITLE_SCENE = preload("res://Scenes/Title.tscn")

@onready var PUCK_SCENE = preload("res://Scenes/Entities/Puck.tscn")

@onready var ARENA_DICT = {
	"Arena4": preload("res://Scenes/Terrain/Arena4.tscn"),
	"Arena3": preload("res://Scenes/Terrain/Arena3.tscn"),
	"Arena2": preload("res://Scenes/Terrain/Arena2.tscn"),
	"Arena1": preload("res://Scenes/Terrain/Arena.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready():
	open_title()

func title_button_pressed(arena):
	close_title()
	open_arena(ARENA_DICT[arena])
	

func arena_exited():
	close_arena()
	open_title()

func open_title():
	var Title = TITLE_SCENE.instantiate()
	add_child(Title)
	
	Title.game_ref(self)

func close_title():
	var children = get_children()
	children[0].queue_free()

func open_arena(ARENA_SCENE):
	var Arena = ARENA_SCENE.instantiate()
	var Puck = PUCK_SCENE.instantiate()
	Puck.position.y += 1
	add_child(Arena)
	add_child(Puck)
	
	#Arena.initialize(Puck)
	Puck.game_ref(self)

func close_arena():
	var children = get_children()
	for child in children:
		child.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
