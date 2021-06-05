extends StaticBody

var vasSound = false
var tvSound = false

func _ready():
	add_to_group("livingRoomFloor")





func _on_vas_body_entered(body):
	if body.is_in_group("livingRoomFloor") and vasSound == false:
		$krukKras.play()
		vasSound = true


func _on_tv__body_entered(body):
	if body.is_in_group("livingRoomFloor") and tvSound == false:
		$TvBreak.play()
		tvSound = true
