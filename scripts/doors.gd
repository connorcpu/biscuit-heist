extends Node2D

@onready var player = get_node("../player")
@onready var tilemaplayer = get_node("/root/Node2D/TileMap/Control Panels")
@onready var sideWall = get_node("/root/Node2D/TileMap/Side Wall")
@onready var topWall = get_node("/root/Node2D/TileMap/Top Walls")

func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int, extra_arg_0: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.is_pressed():
		var diffVect = get_node("area%d" % extra_arg_0).get_global_position() - player.get_global_position()
		var dist = sqrt(pow(abs(diffVect.x), 2) + pow(abs(diffVect.y), 2))
		print("door at dist: %f" % dist)
		if dist < 30 and player.keycards > 0:
			player.decrementKeycards()
			
			var mouse :Vector2 = get_global_mouse_position()
			var cell :Vector2i = tilemaplayer.local_to_map(tilemaplayer.to_local(mouse))
			var tempCoords = tilemaplayer.get_cell_atlas_coords(cell)
			
			#UP door
			if(tempCoords == Vector2i(15, 2)):
				
				tilemaplayer.set_cell(cell, 0, Vector2(16, 2), 0)
				
				topWall.set_cell(Vector2(cell.x + 1, cell.y -1), 0, Vector2(19, 0))
				sideWall.set_cell(Vector2(cell.x + 1, cell.y), 0, Vector2(19, 1))
				sideWall.set_cell(Vector2(cell.x + 1, cell.y +1), 0, Vector2(19, 2))
				
				topWall.set_cell(Vector2(cell.x + 2, cell.y -1), 0, Vector2(-1, -1))
				sideWall.set_cell(Vector2(cell.x + 2, cell.y), 0, Vector2(-1, 1))
				sideWall.set_cell(Vector2(cell.x + 2, cell.y +1), 0, Vector2(-1, -1))
				
			#LEFT going door
			elif(tempCoords == Vector2i(15, 3)):
				
				tilemaplayer.set_cell(Vector2(cell.x - 1, cell.y - 1), 0, Vector2(15, 1))
				tilemaplayer.set_cell(Vector2(cell.x - 1, cell.y - 2), 0, Vector2(15, 0))
				
				topWall.erase_cell(Vector2(cell.x - 1, cell.y - 1))
				topWall.erase_cell(Vector2(cell.x - 1, cell.y - 2))
				
				tilemaplayer.set_cell(cell, 0, Vector2(16, 3), 0)
			
			#RIGHT going door
			elif(tempCoords == Vector2i(16, 4)):
				
				tilemaplayer.set_cell(Vector2(cell.x + 1, cell.y + 1), 0, Vector2(15, 0))
				tilemaplayer.set_cell(Vector2(cell.x + 1, cell.y + 2), 0, Vector2(15, 1))
				
				topWall.erase_cell(Vector2(cell.x + 1, cell.y + 1))
				topWall.erase_cell(Vector2(cell.x + 1, cell.y + 2))
				
				tilemaplayer.set_cell(cell, 0, Vector2(15, 4), 0)
			#var abc :int = tilemap.get_cellv(cell)
			#var new_abc :int = (abc + 1) % 3 # just an example plus 1 modules 3
			#tilemap.set_cellv(cell, new_abc)
			
