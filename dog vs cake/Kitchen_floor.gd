extends StaticBody


var glasSound = false
var glasSound2 = false
var glasSound3 = false


func _ready():
	add_to_group("kitchenFloor")



	


func _on_glas_body_entered(body):
	if body.is_in_group("kitchenFloor") and glasSound == false:
		$GlasKras.play()
		glasSound = true


func _on_glas2_body_entered(body):
	if body.is_in_group("kitchenFloor") and glasSound2 == false:
		$GlasKras.play()
		glasSound2 = true


func _on_glas3_body_entered(body):
	if body.is_in_group("kitchenFloor") and glasSound3 == false:
		$GlasKras.play()
		glasSound3 = true
