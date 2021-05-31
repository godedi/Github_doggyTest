extends Spatial

func _input(event: InputEvent) -> void:
		if event.is_action_pressed("krash"):
			get_node("Spatial2/destruction").destroy()
