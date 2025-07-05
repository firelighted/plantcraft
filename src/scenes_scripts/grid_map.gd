extends GridMap

var just_highlighted_cood
var just_highlighted_type = -1

func highlight_block(world_coordinate: Vector3):
	if just_highlighted_type != -1:
		set_cell_item(just_highlighted_cood, just_highlighted_type)
	var map_coordinate = local_to_map(world_coordinate)
	just_highlighted_cood = map_coordinate
	just_highlighted_type = get_cell_item(map_coordinate)
	set_cell_item(map_coordinate, 6)

func subtract_block():
	set_cell_item(just_highlighted_cood, -1)
	just_highlighted_type = -1

func add_block(world_coordinate: Vector3, block_type: int):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, block_type)
