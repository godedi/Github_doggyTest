extends Spatial

flyingDog = false

func _ready():
	get_node("res://animation/characterdog.gd").flyingDog
	
	if flyingDog == true:
		$InterpolatedCamera.disable = true
		$cameraOnballoon.enable = false
