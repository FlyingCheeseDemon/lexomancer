extends TileMapLayer

signal cell_clicked

func _input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var local_clicked:Vector2 = get_local_mouse_position()
			var pos_clicked:Vector2i = local_to_map(local_clicked)
			if self.get_cell_tile_data(pos_clicked) == null:
				return
			cell_clicked.emit(event,pos_clicked)
