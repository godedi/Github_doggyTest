extends RigidBody


func _ready():
	add_to_group("bodies")


func _on_BlomVas_body_entered(body):
	if body.is_in_group("livingRoomFloor"):
		get_node("destruction").destroy()
