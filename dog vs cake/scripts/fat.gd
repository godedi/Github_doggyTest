extends RigidBody



func _ready():
	add_to_group("bodies")


func _on_fat_body_entered(body):
	if body.is_in_group("kitchenFloor"):
		get_node("Fat_Des").destroy()
