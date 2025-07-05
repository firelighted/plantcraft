extends MeshInstance3D

@export var grass_variant_parent_path : NodePath = "Grass"
@export var mmesh_path : NodePath = "Grass/Varaint2"
@export var instance_parent_path : NodePath = "Instances"
@export var spawn_prefab : PackedScene = preload("res://addons/godot_landscaper/scenes/default_tree.glb")

var grass_variant_parent: Node 
var mmesh: MultiMesh 
var instance_parent: Node 


func _ready() -> void:
	grass_variant_parent = get_node(grass_variant_parent_path)
	mmesh = get_node(mmesh_path).multimesh
	instance_parent = get_node(instance_parent_path)

func grow_at_pos(pos: Vector3):
	print("grow_at_pos")
	var tf = Transform3D()
	tf.origin = pos
	#for variant in grass_variant_parent.get_children():
		#mmesh = variant.multimesh
	#var new_instance_id = mmesh.instance_count
	#mmesh.set_instance_count(new_instance_id + 1)
	#mmesh.set_instance_transform(new_instance_id, tf)
	
	var inst = spawn_prefab.instantiate()
	inst.position = pos
	instance_parent.add_child(inst)
