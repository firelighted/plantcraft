extends Node3D

@onready var leaf_parent_path : NodePath = "Leaves"
@onready var stem_parent_path : NodePath = "Stems"
@onready var leaf_prefab = preload("res://src/scenes_scripts/plant/leaf.tscn")
@onready var stem_prefab = preload("res://src/scenes_scripts/plant/stem.tscn")
@export var current_stage = 1

var leaf_parent : Node3D
var stem_parent : Node3D

func _ready() -> void:
	leaf_parent = get_node(leaf_parent_path)
	stem_parent = get_node(stem_parent_path)
	grow_to(1)
	
func enter_player_aura():
	$AuraToGrowTimer.start()
	
	
func exit_player_aura():
	$AuraToGrowTimer.stop()

func grow_by_amount(m_stages:int):
	grow_to(current_stage + m_stages)
	
func grow_to(growth_stage: int):
	current_stage = growth_stage
	
	# STEM
	for child in stem_parent.get_children():
		child.queue_free()
	for i in range(0, growth_stage):
		var stem = stem_prefab.instantiate()
		stem.position = Vector3.UP * i
		stem_parent.add_child(stem)
	
	# LEAF
	for child in leaf_parent.get_children():
		child.queue_free()
	for i in range(0, growth_stage * 2 + 1):
		var leaf = leaf_prefab.instantiate()
		leaf.position = Vector3.UP * (i/2.0 - 1) + Vector3(cos(i * PI/4.0), 0, sin(i * PI/4.0))
		leaf_parent.add_child(leaf)


func _on_aura_to_grow_timer_timeout() -> void:
	grow_by_amount(1)
