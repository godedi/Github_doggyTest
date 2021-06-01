extends Area

signal cookieCollected

func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	rotate_y(deg2rad(3))


func _on_cookie_body_entered(body):
	if body.name == "doggo":
		$AnimationPlayer.play("EAT")
		$Timer.start()
		$AudioStreamPlayer.play()


func _on_Timer_timeout():
	emit_signal("cookieCollected")
	queue_free()
