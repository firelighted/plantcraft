extends Node2D


func _on_change_world_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes_scripts/flower_world.tscn")
