extends Node

var PARENT

func game_ref(parent):
	PARENT = parent

func _on_texture_button_pressed() -> void:
	PARENT.title_button_pressed("Arena4")


func _on_texture_button_2_pressed() -> void:
	PARENT.title_button_pressed("Arena3")


func _on_texture_button_3_pressed() -> void:
	PARENT.title_button_pressed("Arena1")


func _on_texture_button_4_pressed() -> void:
	PARENT.title_button_pressed("Arena2")
