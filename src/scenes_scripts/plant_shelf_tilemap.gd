extends TileMapLayer

const ATLAS_COOD_X_MAX = 6
const ATLAS_COOD_Y_MAX = 0
const ID_MAX = 6

func grow_tile_cood(tile_cood: Vector2i, grow_amount: int=1):
	#print("grow_tile_cood at ", tile_cood)
	var curr_atl_pos = get_cell_atlas_coords(tile_cood)
	var current_cell_id = get_cell_source_id(tile_cood)
	#print("current_cell_id=", current_cell_id)
	#print("curr_atl_pos=", curr_atl_pos)
	set_cell(tile_cood, current_cell_id, next_atlas_cood(curr_atl_pos))
	#set_cell(tile_cood, min(ID_MAX, current_cell_id + grow_amount))
	#print("new_id=", min(ID_MAX, current_cell_id + grow_amount))


func next_atlas_cood(atlas_cood: Vector2i): 
	var out = atlas_cood + Vector2i(1,0)
	if out.x > ATLAS_COOD_X_MAX:
		out = atlas_cood
	if out.y > ATLAS_COOD_Y_MAX:
		out = atlas_cood
	return out
