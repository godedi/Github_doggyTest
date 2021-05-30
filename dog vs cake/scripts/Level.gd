extends Spatial


func _physics_process(delta):
	get_node("characterDog.gd").flyingDog
	if flyingDog == true:
		$InterpolatedCamera.disable = true
		$cameraOnballoon.enable = false

