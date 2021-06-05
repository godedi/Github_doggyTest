extends StaticBody


var glasSound = false


func _ready():
	add_to_group("kitchenFloor")



	


func _on_glas_body_entered(body):
	if body.is_in_group("kitchenFloor") and glasSound == false:
		$GlasKras.play()
		glasSound = true
