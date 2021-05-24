extends RigidBody


var dropped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bodies")

func _procces(delta):
	if dropped == true:
		apply_impulse(transform.basis.z, -transform.basis.z * 10)
		dropped = false
		
