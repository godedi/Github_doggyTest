extends Area

func _physics_process(delta):
	rotate_y(deg2rad(2))
	
func _ready():
	pass # Replace with function body.


func _on_balloons_body_entered(body):
	if body.name == "doggo":
		queue_free()
