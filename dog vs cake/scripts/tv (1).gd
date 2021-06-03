extends RigidBody

func _ready():
	add_to_group("bodies")


func _on_tv__body_entered(body):
	if body.is_in_group("livingRoomFloor"):
		$"rök".visible = true
