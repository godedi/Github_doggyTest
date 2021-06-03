extends Area


func _ready():
	pass # Replace with function body.




func _on_kartong_body_entered(body):
	if body.name == "doggo":
		get_node("Kartong_Des").destroy()
