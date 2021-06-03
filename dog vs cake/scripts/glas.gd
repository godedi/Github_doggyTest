extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bodies")


func _on_glas_body_entered(body):
	if body.is_in_group("kitchenFloor"):
		get_node("Glas_Des").destroy()
