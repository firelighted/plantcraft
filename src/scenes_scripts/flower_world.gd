extends Node

@export var player_path : NodePath = "Player"
@export var terrain_path : NodePath = "Example/SceneLandscaper/Terrain"
@export var highlight_path : NodePath = "Highlight"

func _on_change_world_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes_scripts/world.tscn")

func highlight_pos(pos: Vector3):
	# TODO figure out why this is so slow in web build
	get_node(highlight_path).position = pos# + Vector3.UP * 2
